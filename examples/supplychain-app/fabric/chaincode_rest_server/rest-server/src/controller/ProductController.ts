import { deserialize, deserializeArray, serialize } from 'class-transformer';
import { Context } from 'koa';
import { Product } from 'models/Product';
import { ProductRequest } from 'models/ProductRequest';
import { UpdateRequest } from 'models/UpdateRequest';
import { SupplyChainClient } from 'SupplyChainClient';

export default class ProductController {
  // GET /product/
  static async getProducts(ctx: Context) {
    const client = new SupplyChainClient(ctx.user);
    await client.connect();
    const network = await client.getNetwork('allchannel');
    const contract = await network.getContract('supplychain');

    // If id param return single product with id
    const queryID = ctx.params.trackingID;
    if (queryID !== undefined) {
      try {
        const response = await contract.submitTransaction('getProduct', queryID);
        const product = deserialize(Product, response.toString());
        ctx.status = 200;
        ctx.body = serialize(product);
      } catch (e) {
        ctx.status = 500;
        ctx.body = { message: e.message };
      }
      return;
    }

    try {
      const response = await contract.submitTransaction('getProduct');
      const products = deserializeArray(Product, response.toString());
      ctx.status = 200;
      ctx.body = serialize(products);
    } catch (e) {
      ctx.status = 500;
      ctx.body = { message: e.message };
    }
  }

  // GET /product/containerless
  static async getContainerlessProducts(ctx: Context) {
    const client = new SupplyChainClient(ctx.user);
    await client.connect();
    const network = await client.getNetwork('allchannel');
    const contract = await network.getContract('supplychain');

    try {
      const response = await contract.submitTransaction('getContainerlessProducts');
      const products = deserializeArray(Product, response.toString());
      ctx.status = 200;
      ctx.body = serialize(products);
    } catch (e) {
      ctx.status = 500;
      ctx.body = { message: e.message };
    }
  }

  // PUT /product/{trackingID}
  static async updateProduct(ctx: Context) {
    // get request rawBody
    const updateRequest = UpdateRequest.fromJSON(ctx.request.rawBody);

    const client = new SupplyChainClient(ctx.user);
    await client.connect();
    const network = await client.getNetwork('allchannel');
    const contract = await network.getContract('supplychain');

    // If id param return single product with id
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

  // POST /product
  static async createProduct(ctx: Context) {
    // get request rawBody
    const request = ProductRequest.fromJSON(ctx.request.rawBody);

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
      const response = await contract.submitTransaction('createProduct', JSON.stringify(request));
      ctx.status = 200;
      ctx.body = response;
    } catch (e) {
      ctx.status = 500;
      ctx.body = { message: e.message };
    }
  }
  // PUT /product/{trackingID}/custodian
  static async claimProduct(ctx: Context) {
    const client = new SupplyChainClient(ctx.user);
    await client.connect();
    const network = await client.getNetwork('allchannel');
    const contract = await network.getContract('supplychain');

    // If id param return single product with id
    const queryID = ctx.params.trackingID;
    try {
      const response = await contract.submitTransaction('claimProduct', queryID, '');
      const trackingID = response.toString();
      ctx.status = 200;
      ctx.body = serialize(trackingID);
    } catch (e) {
      ctx.status = 500;
      ctx.body = { message: e.message };
    }
  }
}
