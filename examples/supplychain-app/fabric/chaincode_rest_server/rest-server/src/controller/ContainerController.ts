import { deserialize, deserializeArray, serialize } from 'class-transformer';
import { Context } from 'koa';
import { Container } from 'models/Container';
import { ContainerRequest } from 'models/ContainerRequest';
import { Contents } from 'models/Contents';
import { UpdateRequest } from 'models/UpdateRequest';
import { SupplyChainClient } from 'SupplyChainClient';

export default class ContainerController {
  // POST /container
  static async createContainer(ctx: Context) {
    // get request rawBody
    const request = ContainerRequest.fromJSON(ctx.request.rawBody);

    const errors = await request.validate();
    if (Object.keys(errors).length > 0) {
      ctx.status = 422;
      ctx.body = errors;
      return;
    }
    const client = new SupplyChainClient(ctx.user);
    await client.connect();
    const network = await client.getNetwork('allchannel');
    const contract = await network.getContract('supplychain');

    try {
      const response = await contract.submitTransaction('createContainer', JSON.stringify(request));
      ctx.status = 200;
      ctx.body = response;
    } catch (e) {
      ctx.status = 500;
      ctx.body = { message: e.message };
    }
  }

  // GET /container/
  static async getContainer(ctx: Context) {
    const client = new SupplyChainClient(ctx.user);
    await client.connect();
    const network = await client.getNetwork('allchannel');
    const contract = await network.getContract('supplychain');

    // If id param return single container with id
    const queryID = ctx.params.trackingID;
    if (queryID !== undefined) {
      try {
        const response = await contract.submitTransaction('getContainer', queryID);
        const container = deserialize(Container, response.toString());
        ctx.status = 200;
        ctx.body = serialize(container);
      } catch (e) {
        ctx.status = 500;
        ctx.body = { message: e.message };
      }
      return;
    }

    try {
      const response = await contract.submitTransaction('getContainer');
      const containers = deserializeArray(Container, response.toString());
      ctx.status = 200;
      ctx.body = serialize(containers);
    } catch (e) {
      ctx.status = 500;
      ctx.body = { message: e.message };
    }
  }
  // PUT /container/{trackingID}
  static async updateContainer(ctx: Context) {
    // get request rawBody
    const updateRequest = UpdateRequest.fromJSON(ctx.request.rawBody);

    const client = new SupplyChainClient(ctx.user);
    await client.connect();
    const network = await client.getNetwork('allchannel');
    const contract = await network.getContract('supplychain');

    // If id param return single container with id
    const queryID = ctx.params.trackingID;
    try {
      const response = await contract.submitTransaction('updateState', queryID, JSON.stringify(updateRequest));
      const trackingID = response.toString();
      ctx.status = 200;
      ctx.body = serialize(trackingID);
    } catch (e) {
      ctx.status = 500;
      ctx.body = { message: e.message };
    }
  }
  // PUT /product/{trackingID}/custodian
  static async claimContainer(ctx: Context) {
    const client = new SupplyChainClient(ctx.user);
    await client.connect();
    const network = await client.getNetwork('allchannel');
    const contract = await network.getContract('supplychain');

    // If id param return single product with id
    const queryID = ctx.params.trackingID;
    try {
      const response = await contract.submitTransaction('claimContainer', queryID, '');
      const trackingID = response.toString();
      ctx.status = 200;
      ctx.body = serialize(trackingID);
    } catch (e) {
      ctx.status = 500;
      ctx.body = { message: e.message };
    }
  }
  // PUT /container/{trackingID}/package
  static async package(ctx: Context) {
    // get request rawBody
    const contentsRequest = Contents.fromJSON(ctx.request.rawBody);

    const client = new SupplyChainClient(ctx.user);
    await client.connect();
    const network = await client.getNetwork('allchannel');
    const contract = await network.getContract('supplychain');

    // If id param return single container with id
    const queryID = ctx.params.trackingID;
    try {
      const response = await contract.submitTransaction('package', queryID, contentsRequest.contents);
      const trackingID = response.toString();
      ctx.status = 200;
      ctx.body = serialize(trackingID);
    } catch (e) {
      ctx.status = 500;
      ctx.body = { message: e.message };
    }
  }
  // PUT /container/{trackingID}/package
  static async unpackage(ctx: Context) {
    // get request rawBody
    const contentsRequest = Contents.fromJSON(ctx.request.rawBody);

    const client = new SupplyChainClient(ctx.user);
    await client.connect();
    const network = await client.getNetwork('allchannel');
    const contract = await network.getContract('supplychain');

    // If id param return single container with id
    const queryID = ctx.params.trackingID;
    try {
      const response = await contract.submitTransaction('unpackage', queryID, contentsRequest.contents);
      const trackingID = response.toString();
      ctx.status = 200;
      ctx.body = serialize(trackingID);
    } catch (e) {
      ctx.status = 500;
      ctx.body = { message: e.message };
    }
  }
}
