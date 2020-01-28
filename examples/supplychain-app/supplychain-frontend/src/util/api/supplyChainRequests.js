import axios from 'axios';
require('dotenv').config()

const ENDPOINT = process.env.REACT_APP_API_ENDPOINT + '/api/v1';
const source = axios.CancelToken.source();

let cancelRequest = () => {
  source.cancel();
  console.log('cancelling...');
}
let getSelf = async () => {
  let nodeInfo =  await axios.get(ENDPOINT + '/node-organization');
  return nodeInfo.data;
}
let getRole = (callback) => {
  axios.get(ENDPOINT + '/node-organizationUnit')
  .then(res=>{
    callback(res.data);
  })
  .catch(err => console.error(err));
}

let getContainers = async () => {
  let containers = await axios.get(ENDPOINT + '/container', {cancelToken: source.token});
  return containers.data;
}

let getContainerByID = async trackingID => {
  let container = await axios.get(ENDPOINT + `/container/${trackingID}`);
  return container.data;
}

let getProducts = async () => {
  let products = await axios.get(ENDPOINT + '/product');
  return products.data;
}

let getProductByID = async trackingID => {
  let product = await axios.get(ENDPOINT + `/product/${trackingID}`);
  return product.data;
}

let getContainerlessProducts = async () => {
  let products = await axios.get(ENDPOINT + `/product/containerless`);
  return products.data;
}

let newProduct = async productRequestBody => {
  let newProduct = await axios.post(ENDPOINT + '/product', productRequestBody);
  return newProduct.data;
}

let newContainer = async containerRequestBody => {
  let newContainer = await axios.post(ENDPOINT + '/container', containerRequestBody);
  return newContainer.data;
}

let locationHistory = async (trackingID)  => {
  let history = await axios.get(ENDPOINT + `/${trackingID}/history`);
  return history.data;
}

let receiveProduct  = async(trackingID) => {
  let res = await axios.put(ENDPOINT + `/product/${trackingID}/custodian`);
  return res.data;
}

let receiveContainer  = async(trackingID) => {
  let res = await axios.put(ENDPOINT + `/container/${trackingID}/custodian`);
  return res.data;
}

let packageGood = async(containerID, contents) => {
  let res = await axios.put(ENDPOINT + `/container/${containerID}/package`,contents);
  return res.data
}

let unPackageGood = async(containerID, contents) => {
  let res = await axios.put(ENDPOINT + `/container/${containerID}/unpackage`,contents);
  return res.data
}

let scan = async(trackingID) => {
  let res = await axios.get(ENDPOINT + `/${trackingID}/scan`);
  return res.data
}

export default {
  cancelRequest,
  getSelf,
  getRole,
  getContainers,
  getContainerByID,
  getProducts,
  getProductByID,
  getContainerlessProducts,
  newProduct,
  newContainer,
  locationHistory,
  receiveProduct,
  receiveContainer,
  packageGood,
  unPackageGood,
  scan,
};
