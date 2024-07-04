import argparse
import os
import random
import requests
import string
import ujson as json
import base58
import re
import html

from crypto.bls.bls_crypto import BlsGroupParamsLoader
from crypto.bls.bls_factory import BlsFactoryCrypto
from plenum.bls.bls_crypto_factory import BlsFactoryIndyCrypto
from crypto.bls.bls_key_manager import BlsKeyManager
from crypto.bls.indy_crypto.bls_crypto_indy_crypto import BlsCryptoSignerIndyCrypto, BlsGroupParamsLoaderIndyCrypto

from plenum.common.signer_did import DidSigner

from libnacl import crypto_sign_seed_keypair
from stp_core.crypto.util import ed25519PkToCurve25519 as ep2c, ed25519SkToCurve25519 as es2c
from zmq.utils import z85


class IdentityCryptoGeneratorV2:

    def __init__(self, identity_name, vault_path):
        self.vault_path = vault_path
        self.identity_name = identity_name
        self.seed = self.get_signing_seed()
        self.did = DidSigner(seed=self.seed).identifier
        self.bls_generator = BlsGenerator(self.seed)
        self.public_key = None
        self.secret_key = None
        self.sig_key = None
        self.verif_key = None

    def generate(self):
        verif_key, sig_key = crypto_sign_seed_keypair(self.seed)
        public_key, secret_key = ep2c(verif_key), es2c(sig_key)

        public_key_file = self.cert_file_from_key(public_key=z85.encode(public_key).decode("utf-8"), private_key=None)
        private_key_file = self.cert_file_from_key(public_key=z85.encode(public_key).decode("utf-8"), private_key=z85.encode(secret_key).decode("utf-8"))
        verif_key_file = self.cert_file_from_key(public_key=z85.encode(verif_key).decode("utf-8"), private_key=None)
        sig_key_file = self.cert_file_from_key(public_key=z85.encode(verif_key).decode("utf-8"), private_key=z85.encode(sig_key[:32]).decode("utf-8"))

        public_key = base58.b58encode(public_key).decode("utf-8")
        verif_key = base58.b58encode(verif_key).decode("utf-8")

        sk, pk, key_proof = self.bls_generator.generate()
        bls = Bls(pk=pk, sk=sk, key_pop=key_proof)

        node = Crypto(name=self.identity_name, public_key=public_key, public_key_file=public_key_file,
                      secret_key=secret_key, secret_key_file=private_key_file,
                      sig_key=sig_key, sig_key_file=sig_key_file,
                      verif_key=verif_key, verif_key_file=verif_key_file,
                      bls_keys=bls, is_client=False)

        client = Crypto(name=self.identity_name, public_key=public_key, public_key_file=public_key_file,
                        secret_key=secret_key, secret_key_file=private_key_file,
                        sig_key=sig_key, sig_key_file=sig_key_file,
                        verif_key=verif_key, verif_key_file=verif_key_file,
                        bls_keys=bls, is_client=True)
        v2_path = self.vault_path.replace(".", "/data.",1)
        return Identity(
            name=self.identity_name, vault_path=v2_path, node=node, client=client, did=self.did, seed=self.seed
        )

    def get_signing_seed(self, size=32):
        return ''.join(random.choice(string.hexdigits)
            for _ in range(size)).encode()

    def cert_file_from_key(self, public_key, private_key):
        file = 'metadata\ncurve\n    public-key = \"{}\"\n'.format(public_key)
        if private_key:
            file = '{}    secret-key = \"{}\"\n'.format(file, private_key)
        return file


class BlsGenerator(BlsFactoryIndyCrypto):

    def __init__(self, seed):
        self.seed = seed

    def generate(self):
        return self.generate_bls_keys(seed=self.seed)

    def _create_group_params_loader(self) -> BlsGroupParamsLoader:
        return BlsGroupParamsLoaderIndyCrypto()

    def _get_bls_crypto_signer_class(self):
        return BlsCryptoSignerIndyCrypto

    def _create_key_manager(self, group_params) -> BlsKeyManager:
        pass

    def _create_bls_crypto_signer(self, sk, pk, group_params):
        pass

    def _create_bls_crypto_verifier(self, group_params):
        pass


class Identity:

    def __init__(self, name, vault_path, node, client, did, seed):
        self.name = name
        self.vault_path = vault_path
        self.node = node
        self.client = client
        self.did = did
        self.seed = seed

    def to_dict(self):
        value = {
            self.name: {
                'identity': {
                    'private': {
                        'seed': self.seed
                    },
                    'public': {
                        'did': self.did
                    }
                },
                'node': self.node.to_dict(),
                'client': self.client.to_dict()
            }
        }
        return self.vault_path_to_json(value)

    def vault_path_to_json(self, json_value):
        final_json = {}
        keys = self.vault_path.split('.')
        for index, key in reversed(list(enumerate(keys))):
            previous_json = final_json.copy()
            final_json = {}
            if index == len(keys) - 1:
                final_json[key] = json_value
            else:
                final_json[key] = previous_json
        return final_json


class Crypto:

    def __init__(self, name, public_key, public_key_file,
                 secret_key, secret_key_file,
                 sig_key, sig_key_file,
                 verif_key, verif_key_file,
                 bls_keys, is_client=False):
        self.name = name
        self.is_client = is_client
        self.public_keys = Keys(key=public_key, file=public_key_file)
        self.private_keys = Keys(key=secret_key, file=secret_key_file)
        self.bls_keys = bls_keys
        self.sig_keys = Keys(key=sig_key, file=sig_key_file)
        self.verif_keys = Keys(key=verif_key, file=verif_key_file)

    def to_dict(self):
        json_file = {
            'private': {
                'private_keys': {
                    self.secret_key_format(): self.private_keys.file
                },
                'sig_keys': {
                    self.secret_key_format(): self.sig_keys.file
                }
            },
            'public': {
                'public_keys': {
                    'public_key': self.public_keys.key,
                    self.bootstrap_key_format(): self.public_keys.file
                },
                'verif_keys': {
                    'verification-key': self.verif_keys.key,
                    self.bootstrap_key_format(): self.verif_keys.file
                }
            }
        }

        if self.is_client:
            return json_file
        else:
            json_file['public']['bls_keys'] = {
                'bls_pk': self.bls_keys.pk,
                'bls-public-key': self.bls_keys.pk,
                'bls-key-pop': self.bls_keys.key_pop
            }
            json_file['private']['bls_keys'] = {
                'bls_sk': self.bls_keys.sk
            }
            return json_file

    def bootstrap_key_format(self):
        if self.is_client:
            return '{}C.key'.format(self.name)
        else:
            return '{}.key'.format(self.name)

    def secret_key_format(self):
        if self.is_client:
            return '{}C.key_secret'.format(self.name)
        else:
            return '{}.key_secret'.format(self.name)


class Keys:

    def __init__(self, key, file):
        self.key = key
        self.file = file


class Bls:

    def __init__(self, pk, sk, key_pop):
        self.pk = pk
        self.sk = sk
        self.key_pop = key_pop


class VaultUploader:

    def __init__(self, address, version):
        self.address = address
        self.version = version

    def upload(self, data):
        vault_paths = self.transform_to_paths(json_file=data.to_dict())
        token = os.environ['VAULT_TOKEN']
        headers = {'Content-type': 'application/json', 'X-Vault-Token': token}

        provider = list(data.to_dict().keys())[0].replace("/data", "")
        provider_url = '{}/v1/sys/mounts/{}/tune'.format(self.address, provider)
        provider_exists, _ = self.read_data(url=provider_url, headers=headers)

        if not provider_exists:
            url = '{}/v1/sys/mounts/{}'.format(self.address, provider)            
            self.send_data(url=url, headers=headers, data={"type": "kv", "options" : {"version" : self.version }})

        organisation = '{}/{}'.format(data.vault_path.replace('.', '/'), data.name)
        print('organisation: ',organisation)
        organisation_url = '{}/v1/{}'.format(self.address, organisation)
        organisation_exists, _ = self.read_datav2(url=organisation_url, headers=headers)

        if not organisation_exists:
            self.process_data(vault_paths=vault_paths, headers=headers)
        else:
            print('Path {} for Vault exists.'.format(organisation))

    def process_data(self, vault_paths, headers):
        for path in vault_paths:
            for key, value in path.items():
                url = '{}/v1{}'.format(self.address, key)
                exists_path, vault_data = self.read_datav2(url=url, headers=headers)                
                if exists_path:
                    data = {**vault_data, **value}
                else:
                    data = value
                self.send_data(url=url, data={"data" : data}, headers=headers)

    def send_data(self, url, data, headers):
        print('url: {}'.format(url))
        requests.post(url=url, headers=headers, data=json.dumps(data), verify=True)
        print('=====================')

    def read_data(self, url, headers):
        response = requests.get(url=url, headers=headers)
        json_content = json.loads(response.content)
        return response.status_code == 200, json_content['data'] if 'data' in json_content else None
    
    def read_datav2(self, url, headers):
        response = requests.get(url=url, headers=headers)
        json_content = json.loads(response.content)
        return response.status_code == 200, json_content['data']['data'] if 'data' in json_content else None

    def transform_to_paths(self, json_file):
        return self.create_paths(json_file)

    def create_paths(self, dictionary):
        def path_iteration(dictionary, path):
            paths = []
            for key, value in dictionary.items():
                if isinstance(value, dict):
                    paths += path_iteration(value, '{}/{}'.format(path, key))
                else:
                    paths.append({path: {key: value}})
            return paths
        return path_iteration(dictionary, '')

def prevent_injections(input_string):
    # Regex pattern to prevent SQL injection
    sql_injection_pattern = re.compile(r"\b(?:SELECT|INSERT|UPDATE|DELETE|DROP|UNION|CREATE|ALTER|EXEC|--)\b", re.IGNORECASE)

    # Regex pattern to prevent HTML injection
    html_injection_pattern = re.compile(r"<[a-z][\s\S]*>", re.IGNORECASE)

    # Check for SQL injection
    if sql_injection_pattern.search(input_string):
        raise ValueError("Invalid input. Detected potential SQL injection attempt.")

    # Check for HTML injection
    if html_injection_pattern.search(input_string):
        raise ValueError("Invalid input. Detected potential HTML injection attempt.")

    # HTML escape the input
    escaped_string = html.escape(input_string)

    return escaped_string

class IdentityCreatorV2:

    @classmethod
    def process(cls):
        parser = argparse.ArgumentParser(description="Generate pool transactions")
        parser.add_argument('--identity_name', type=prevent_injections, required=True,
                            help='Identity name')
        parser.add_argument('--vault_path', type=prevent_injections, required=True,
                            help='Vault path')
        parser.add_argument('--target', type=prevent_injections, required=False, default='console',
                            help='Output type for identity.')
        parser.add_argument('--vault_address', type=prevent_injections, required=False, default='https://localhost:8200',
                            help='Address for vault server.')
        parser.add_argument('--version', type=prevent_injections, required=False, default='1',
                            help='Vault KV version')

        args = parser.parse_args()

        identity_crypto_generatorv2 = IdentityCryptoGeneratorV2(
            identity_name=args.identity_name, vault_path=args.vault_path
        )
        vault = VaultUploader(address=args.vault_address,version=args.version)

        identity = identity_crypto_generatorv2.generate()
        if args.target.lower() == 'vault' and args.vault_address is not None:
            vault.upload(data=identity)
        elif args.target.lower() == 'console':
            print(json.dumps(identity.to_dict()))
        else:
            print('Wrong parameters.')
