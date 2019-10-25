const axios = require ('axios')
const {endpoint} = require('./config.js')


let getSelf = async () => {
  let nodeInfo =  await axios.get(endpoint + '/node-organization');
  return nodeInfo.data;
}

let getRole = async () => {
  let role = await axios.get(endpoint + '/node-organizationUnit');
  return (role.data);
}
let scan = async(trackingID) => {
  let res = await axios.get(endpoint + `/${trackingID}/scan`);
  return res.data
}

let getContainers = async () => {
  let containers = await axios.get(endpoint + '/container');
  return containers.data;
}

let getContainerByID = async trackingID => {
  let container = await axios.get(endpoint + `/container/${trackingID}`);
  return container.data;
}

let getProducts = async () => {
  let products = await axios.get(endpoint + '/product');
  return products.data;
}

let getProductByID = async trackingID => {
  let product = await axios.get(endpoint + `/product/${trackingID}`);
  return product.data;
}

let getContainerlessProducts = async () => {
  let products = await axios.get(endpoint + `/product/containerless`);
  return products.data;
}

let newProduct = async productRequestBody => {
  let newProduct = await axios.post(endpoint + '/product', productRequestBody);
  return newProduct.data;
}

let newContainer = async containerRequestBody => {
  let newContainer = await axios.post(endpoint + '/container', containerRequestBody);
  return newContainer.data;
}

let locationHistory = async (trackingID)  => {
  let history = await axios.get(endpoint + `/${trackingID}/history`);
  return history.data;
}

let receiveProduct  = async(trackingID) => {
  let res = await axios.put(endpoint + `/product/${trackingID}/custodian`);
  return res.data;
}

let receiveContainer  = async(trackingID) => {
  let res = await axios.put(endpoint + `/container/${trackingID}/custodian`);
  return res.data;
}

let packageGood = async(containerID, contents) => {
  let res = await axios.put(endpoint + `/container/${containerID}/package`,contents);
  return res.data
}

let unPackageGood = async(containerID, contents) => {
  let res = await axios.put(endpoint + `/container/${containerID}/unpackage`,contents);
  return res.data
}

module.exports = {
  getSelf,
  getRole,
  scan,
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
}
