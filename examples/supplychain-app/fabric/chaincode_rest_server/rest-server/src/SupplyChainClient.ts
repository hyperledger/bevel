import { Gateway } from 'fabric-network';
import { readFileSync } from 'fs';
import * as yaml from 'js-yaml';
import { User } from './User';

export class SupplyChainClient extends Gateway {
  user: User;

  constructor(user: User) {
    super();
    this.user = user;
  }

  async connect() {
    const connectionProfile = yaml.safeLoad(readFileSync('fabric-connection.yaml', 'utf8'));
    // Set connection options; identity and wallet
    const connectionOptions = {
      identity: this.user.identityLabel,
      wallet: this.user.wallet,
      discovery: { enabled: true, asLocalhost: false },
      clientTlsIdentity: this.user.identityLabel
    };
    const connection = await super.connect(
      connectionProfile,
      connectionOptions
    );
    console.debug('Fabric Network Connection Successful');
    return connection;
  }
}
