import argparse
import ipaddress
import os
from collections import namedtuple
import random
import string
import fileinput
import shutil

from common.exceptions import PlenumValueError

from ledger.genesis_txn.genesis_txn_file_util import create_genesis_txn_init_ledger
from plenum.common.plenum_protocol_version import PlenumProtocolVersion

from stp_core.crypto.nacl_wrappers import Signer

from plenum.common.member.member import Member
from plenum.common.member.steward import Steward

from plenum.common.keygen_utils import initNodeKeysForBothStacks, init_bls_keys
from plenum.common.constants import STEWARD, TRUSTEE
from plenum.common.util import hexToFriendly, is_hostname_valid
from plenum.common.signer_did import DidSigner
from plenum.common.config_helper import PConfigHelper, PNodeConfigHelper
from stp_core.common.util import adict
from libnacl import randombytes


CLIENT_CONNECTIONS_LIMIT = 500


class RealNetworkSetup:
    @staticmethod
    def getNumberFromName(name: str) -> int:
        if name.startswith("Node"):
            return int(name[4:])
        elif name.startswith("Steward"):
            return int(name[7:])
        elif name.startswith("Client"):
            return int(name[6:])
        else:
            raise ValueError("Cannot get number from {}".format(name))

    @staticmethod
    def get_signing_seed(size=32):
        return ''.join(random.choice(string.hexdigits)
           for _ in range(size)).encode()

    @staticmethod
    def get_nym_from_verkey(verkey: bytes):
        return hexToFriendly(verkey)

    @staticmethod
    def writeNodeParamsFile(filePath, name, nIp, nPort, cIp, cPort):
        contents = [
            'NODE_NAME={}'.format(name),
            'NODE_IP={}'.format(nIp),
            'NODE_PORT={}'.format(nPort),
            'NODE_CLIENT_IP={}'.format(cIp),
            'NODE_CLIENT_PORT={}'.format(cPort),
            'CLIENT_CONNECTIONS_LIMIT={}'.format(CLIENT_CONNECTIONS_LIMIT)
        ]
        with open(filePath, 'w') as f:
            f.writelines(os.linesep.join(contents))

    @classmethod
    def bootstrap_real_nodes_core(
            cls,
            config,
            network,
            appendToLedgers,
            domainTxnFieldOrder,
            trustee_def,
            steward_defs,
            node_defs,
            node_params_file_name,
            config_helper_class=PConfigHelper,
            node_config_helper_class=PNodeConfigHelper,
            chroot: str=None):

        # if not local_nodes:
        #     local_nodes = {}
        # try:
        #     if isinstance(local_nodes, int):
        #         _local_nodes = {local_nodes}
        #     else:
        #         _local_nodes = {int(_) for _ in local_nodes}
        # except BaseException as exc:
        #     raise RuntimeError('nodeNum must be an int or set of ints') from exc

        config.NETWORK_NAME = network

        config_helper = config_helper_class(config, chroot=chroot)
        os.makedirs(config_helper.genesis_dir, exist_ok=True)
        genesis_dir = config_helper.genesis_dir
        keys_dir = config_helper.keys_dir

        poolLedger = cls.init_pool_ledger(appendToLedgers, genesis_dir, config)
        domainLedger = cls.init_domain_ledger(appendToLedgers, genesis_dir,
                                              config, domainTxnFieldOrder)

        # TODO: make it parameter for generate genesis txns script
        genesis_protocol_version = None

        # 1. INIT DOMAIN LEDGER GENESIS FILE
        seq_no = 1
        trustee_txn = Member.nym_txn(trustee_def.nym, verkey=trustee_def.verkey, role=TRUSTEE,
                                     seq_no=seq_no,
                                     protocol_version=genesis_protocol_version)
        seq_no += 1
        domainLedger.add(trustee_txn)

        for sd in steward_defs:
            nym_txn = Member.nym_txn(sd.nym, verkey=sd.verkey, role=STEWARD, creator=trustee_def.nym,
                                     seq_no=seq_no,
                                     protocol_version=genesis_protocol_version)
            seq_no += 1
            domainLedger.add(nym_txn)

        # 2. INIT KEYS AND POOL LEDGER GENESIS FILE
        seq_no = 1
        for nd in node_defs:
            print("------------------------------------------------------------------------------------------------------")
            print("Node name:", nd.name)
            # if nd.idx in _local_nodes:
            _, verkey, blskey, key_proof = initNodeKeysForBothStacks(nd.name, keys_dir, nd.sigseed, override=True)
            verkey = verkey.encode()
            assert verkey == nd.verkey

            # if nd.ip != '127.0.0.1':
            #     paramsFilePath = os.path.join(config.GENERAL_CONFIG_DIR, node_params_file_name)
            #     print('Nodes will not run locally, so writing {}'.format(paramsFilePath))
            #     RealNetworkSetup.writeNodeParamsFile(paramsFilePath, nd.name,
            #                                          "0.0.0.0", nd.port,
            #                                          "0.0.0.0", nd.client_port)

            print("This node with name {} will use ports {} and {} for nodestack and clientstack respectively"
                  .format(nd.name, nd.port, nd.client_port))
            # else:
            #     verkey = nd.verkey
            #     blskey, key_proof = init_bls_keys(keys_dir, nd.name, nd.sigseed)
            node_nym = cls.get_nym_from_verkey(verkey)

            node_txn = Steward.node_txn(nd.steward_nym, nd.name, node_nym,
                                        nd.ip, nd.port, nd.client_port, blskey=blskey,
                                        bls_key_proof=key_proof,
                                        seq_no=seq_no,
                                        protocol_version=genesis_protocol_version)
            seq_no += 1
            poolLedger.add(node_txn)
            print("------------------------------------------------------------------------------------------------------\n")

        poolLedger.stop()
        domainLedger.stop()

    @classmethod
    def init_pool_ledger(cls, appendToLedgers, genesis_dir, config):
        pool_txn_file = cls.pool_ledger_file_name(config)
        pool_ledger = create_genesis_txn_init_ledger(genesis_dir, pool_txn_file)
        if not appendToLedgers:
            pool_ledger.reset()
        return pool_ledger

    @classmethod
    def init_domain_ledger(cls, appendToLedgers, genesis_dir, config, domainTxnFieldOrder):
        domain_txn_file = cls.domain_ledger_file_name(config)
        domain_ledger = create_genesis_txn_init_ledger(genesis_dir, domain_txn_file)
        if not appendToLedgers:
            domain_ledger.reset()
        return domain_ledger

    @classmethod
    def pool_ledger_file_name(cls, config):
        return config.poolTransactionsFile

    @classmethod
    def domain_ledger_file_name(cls, config):
        return config.domainTransactionsFile

    @classmethod
    def bootstrap_real_nodes(cls, config, node_params_file_name, domainTxnFieldOrder,
                           config_helper_class=PConfigHelper, node_config_helper_class=PNodeConfigHelper,
                           chroot: str=None):
        parser = argparse.ArgumentParser(description="Generate pool transactions")
        parser.add_argument('--nodes', required=True,
                            help='node count should be less than 100',
                            type=cls._bootstrap_args_type_node_count)
        parser.add_argument('--nodeNames', required=True,
                            help='Comma separated names of the nodes',
                            type=cls._bootstrap_args_type_node_name)
        parser.add_argument('--ips', required=True,
                            help='IPs/hostnames of the nodes, provide comma '
                                 'separated IPs',
                            type=cls._bootstrap_args_type_ips_hosts)
        parser.add_argument('--nodePorts', required=True,
                            help='Comma separated node ports',
                            type=cls._bootstrap_args_type_port)
        parser.add_argument('--clientPorts', required=True,
                            help='Comma separated client ports',
                            type=cls._bootstrap_args_type_port)
        parser.add_argument('--network',
                            help='Network name (default sandbox)',
                            type=str,
                            default="sandbox",
                            required=False)
        parser.add_argument(
            '--appendToLedgers',
            help="Determine if ledger files needs to be erased "
            "before writing new information or not.",
            action='store_true')

        args = parser.parse_args()

        # if isinstance(args.nodeNum, int):
        #     if not (1 <= args.nodeNum <= args.nodes):
        #         raise PlenumValueError(
        #             'args.nodeNum', args.nodeNum,
        #             ">= 1 && <= args.nodes {}".format(args.nodes)
        #         )
        # elif isinstance(args.nodeNum, list):
        #     if any([True for x in args.nodeNum if not (1 <= x <= args.nodes)]):
        #         raise PlenumValueError(
        #             'some items in nodeNum list', args.nodeNum,
        #             ">= 1 && <= args.nodes {}".format(args.nodes)
        #         )

        # node_num = [args.nodeNum, None] if args.nodeNum else [None]

        # TODO check that node_names etc. number matches nodes count

        steward_defs, node_defs = cls.gen_defs(args.ips, args.nodes, args.nodeNames, args.nodePorts, args.clientPorts)
        trustee_def = cls.gen_trustee_def(1)

        # if args.nodeNum:
        #     # update network during node generation only
        #     # edit NETWORK_NAME in config
        #     for line in fileinput.input(['/etc/indy/indy_config.py'], inplace=True):
        #         if 'NETWORK_NAME' not in line:
        #             print(line, end="")
        #     with open('/etc/indy/indy_config.py', 'a') as cfgfile:
        #         cfgfile.write("NETWORK_NAME = '{}'".format(args.network))

        # for n_num in range(1, args.nodes + 1):
        cls.bootstrap_real_nodes_core(config, args.network, args.appendToLedgers, domainTxnFieldOrder, trustee_def,
                                   steward_defs, node_defs, node_params_file_name,
                                   config_helper_class, node_config_helper_class)

    @staticmethod
    def _bootstrap_args_type_node_count(nodesStrArg):
        if not nodesStrArg.isdigit():
            raise argparse.ArgumentTypeError('should be a number')
        n = int(nodesStrArg)
        if n > 100:
            raise argparse.ArgumentTypeError(
                "Cannot run {} nodes for testing purposes as of now. "
                "This is not a problem with the protocol but some placeholder "
                "rules we put in place which will be replaced by our "
                "Governance model. Going to run only 100".format(n)
            )
        if n <= 0:
            raise argparse.ArgumentTypeError('should be > 0')
        return n

    @staticmethod
    def _bootstrap_args_type_ips_hosts(ips_hosts_str_arg):
        ips = []
        for arg in ips_hosts_str_arg.split(','):
            arg = arg.strip()
            try:
                ipaddress.ip_address(arg)
            except ValueError:
                if not is_hostname_valid(arg):
                    raise argparse.ArgumentTypeError(
                        "'{}' is not a valid IP or hostname".format(arg)
                    )
                else:
                    ips.append(arg)
            else:
                ips.append(arg)
        return ips

    @staticmethod
    def _bootstrap_args_type_node_name(node_names_str_arg):
        node_names = []
        for arg in node_names_str_arg.split(','):
            arg = arg.strip()
            node_names.append(arg)
        return node_names

    @staticmethod
    def _bootstrap_args_type_port(ports_str_arg):
        ports = []
        for arg in ports_str_arg.split(','):
            arg = arg.strip()
            if not arg.isdigit():
                raise argparse.ArgumentTypeError('should be a number')
            ports.append(arg)
        return ports

    @classmethod
    def gen_defs(cls, ips, node_count, node_names, node_ports, client_ports):
        """
        Generates some default steward and node definitions for tests
        :param ips: array of ip addresses
        :param node_count: number of stewards/nodes
        :return: duple of steward and node definitions
        """

        steward_defs = []
        node_defs = []
        for i in range(1, node_count + 1):
            d = adict()
            d.name = "Steward" + str(i)
            d.sigseed = cls.get_signing_seed()
            s_signer = DidSigner(seed=d.sigseed)
            d.nym = s_signer.identifier
            d.verkey = s_signer.verkey
            steward_defs.append(d)

            name = node_names[i - 1]
            sigseed = cls.get_signing_seed()
            node_defs.append(NodeDef(
                name=name,
                ip=ips[i - 1],
                port=node_ports[i - 1],
                client_port=client_ports[i - 1],
                idx=i,
                sigseed=sigseed,
                verkey=Signer(sigseed).verhex,
                steward_nym=d.nym))
        return steward_defs, node_defs

    @classmethod
    def gen_client_def(cls, idx):
        d = adict()
        d.name = "Client" + str(idx)
        d.sigseed = cls.get_signing_seed()
        c_signer = DidSigner(seed=d.sigseed)
        d.nym = c_signer.identifier
        d.verkey = c_signer.verkey
        return d

    @classmethod
    def gen_client_defs(cls, clientCount):
        return [cls.gen_client_def(idx) for idx in range(1, clientCount + 1)]

    @classmethod
    def gen_trustee_def(cls, idx):
        print ("------------------------------------------------------------------------------------------------------")
        d = adict()
        d.name = 'Trustee' + str(idx)
        print ("Trustee name:", d.name)
        d.sigseed = cls.get_signing_seed()
        print("Generating keys for provided seed", d.sigseed)
        t_signer = DidSigner(seed=d.sigseed)
        d.nym = t_signer.identifier
        d.verkey = t_signer.verkey
        print("------------------------------------------------------------------------------------------------------\n")
        return d


NodeDef = namedtuple('NodeDef', 'name, ip, port, client_port, '
                                'idx, sigseed, verkey, steward_nym')
