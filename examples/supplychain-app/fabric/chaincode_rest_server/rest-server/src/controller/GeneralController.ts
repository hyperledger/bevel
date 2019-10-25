import { Context } from 'koa';
import { SupplyChainClient } from 'SupplyChainClient';

export default class GeneralController {
  // GET /:trackingID/scan
  static async scan(ctx: Context) {
    const client = new SupplyChainClient(ctx.user);
    await client.connect();
    const network = await client.getNetwork('allchannel');
    const contract = await network.getContract('supplychain');

    // If id param return single product with id
    const queryID = ctx.params.trackingID;

    try {
      const response = await contract.submitTransaction('scan', queryID);
      ctx.status = 200;
      ctx.body = response;
    } catch (e) {
      ctx.status = 500;
      ctx.body = { message: e.message };
    }
  }

  static async getOrganization(ctx: Context) {
    ctx = await GeneralController.getIdentity(ctx, 'organization');
  }

  static async getOrganizationUnit(ctx: Context) {
    ctx = await GeneralController.getIdentity(ctx, 'organizationUnit');
  }

  static async getHistory(ctx: Context) {
    const client = new SupplyChainClient(ctx.user);
    await client.connect();
    const network = await client.getNetwork('allchannel');
    const contract = await network.getContract('supplychain');

    // If id param return single product with id
    const queryID = ctx.params.trackingID;

    try {
      const response = await contract.submitTransaction('history', queryID);
      ctx.status = 200;
      ctx.body = response;
    } catch (e) {
      ctx.status = 500;
      ctx.body = { message: e.message };
    }
  }

  private static async getIdentity(ctx: Context, type: 'organization' | 'organizationUnit'): Promise<Context> {
    const client = new SupplyChainClient(ctx.user);
    await client.connect();
    const network = await client.getNetwork('allchannel');
    const contract = await network.getContract('supplychain');

    try {
      const response = await contract.submitTransaction('getIdentity');
      ctx.status = 200;
      ctx.body = {};
      ctx.body[type] = JSON.parse(response.toString())[type];
    } catch (e) {
      ctx.status = 500;
      ctx.body = { message: e.message };
    }

    return ctx;
  }
}
