import { FileSystemWallet, Wallet, X509WalletMixin } from 'fabric-network';

export class User {
  identityLabel: string;
  wallet: Wallet;

  constructor(walletLocation: string, username: string) {
    this.wallet = new FileSystemWallet(walletLocation);
    this.identityLabel = username;
  }

  async createIdentity(cert: string, key: string, MSP: string) {
    const identity = X509WalletMixin.createIdentity(MSP, cert, key);
    await this.wallet.import(this.identityLabel, identity);
  }
}
