import * as geoCode from 'scripts/geoCode';

let sortObject = {
  sortCiteria: ""
}

export async function mutateNodes(nodes){
  let formatedNodes = parseNodes(nodes);
  let uniqueLocations = getLocations(formatedNodes);
  let uniqueLocationsMap = await geoCode.nodesLatLong(uniqueLocations);
  formatedNodes = geoCodeNodes(formatedNodes, uniqueLocationsMap);
  return formatedNodes;
}

export const parseNodes = (nodes) => {
  let nodeArray = []
  for(let i of nodes){
    nodeArray = parseParties(i, nodeArray);
  }
  return nodeArray;
}

function parseParties(node, formatedNodeArray){
  for(let i in node.parties){
    formatedNodeArray.push(parseParty(node.nodeKey, node.parties[i]));
  }
  return formatedNodeArray
}

function parseParty(nodeKey, party){
  let partyObj = {}
  partyObj = parseX500(party, partyObj);
  partyObj = parseKey(party, partyObj);
  partyObj.nodeKey = nodeKey;
  return partyObj
}

function parseX500(party, partyObj){  
  let tokens = party.name.split(',');
  for(let i in tokens){
    tokens[i] = tokens[i].trim();
    let letTokenSplit = tokens[i].split('=');
    partyObj[letTokenSplit[0]] = letTokenSplit[1];
  }
  return partyObj;
}

function parseKey(party, partyObj){  
  partyObj.key = party.key;
  return partyObj
}

export const getHeaders = (list) => {
  const headerArray = [];
  console.log(list);
  if(list.size == 0) return headerArray
  for(let value of list.values()){
    headerArray.push(value);
  }
  return headerArray;
}

export const getLocations = (nodes) => {
  let locationArray = [];
  for(let i in nodes){
    // convert lat/long/city to just city
    var tempLoc = nodes[i].L;
    var res = tempLoc.split("/");
    var tempCity = res[res.length-1]; // get the last of the array
    let obj = { city: tempCity, country: nodes[i].C }
    locationArray.push(obj);
  }
  locationArray = uniqueList(locationArray);
  return locationArray
}

function uniqueList(locationArray){
  const unique = locationArray.filter(uniqueObjects);
  return unique;
}

function uniqueObjects(value, index, self){
  for(let i = 0; i < index; i++){
    if(self[i].city === self[index].city && self[i].country === self[index].country) return false;
  }
  return true;
}

export const geoCodeNodes = (nodesArray, locationsMap) => {
  let nodes = nodesArray;
  nodes = nodes.map((node, index) => {
    // convert lat/long/city to just city
    var tempLoc = node.L;
    var res = tempLoc.split("/");
    var tempCity = res[res.length-1]; // get the last of the array    
    let keyObj = `${tempCity}${node.C}`
    node.lat = locationsMap.get(keyObj).lat;
    node.lng = locationsMap.get(keyObj).lng;
    return node;    
  });
  return nodes;
}

export const isNotary = (nodes, notaries) => {
  let notaryMap = createNotaryMap(notaries);
  for(let node in nodes){
    if(notaryMap.get(nodes[node].key)) { 
      nodes[node].N = true;
    }
    else{
      nodes[node].N = false;
    }
  }
  return nodes;
}

function createNotaryMap(notaries){
  let notaryMap = new Map();
  notaries.forEach(notary => {
    notaryMap.set(notary.notaryInfo.identity.owningKey, notary.notaryInfo.identity.owningKey)
  })
  return notaryMap
}

export const sortNodes = (sortValue, nodeArray, notaryMap) => {
  let sortKey
  for (var [key, value] of notaryMap) {
    if(value === sortValue) sortKey = key;
  }
  if(sortKey === sortObject.sortCiteria) return nodeArray.reverse();
  else sortObject.sortCiteria = sortKey;

  nodeArray.sort((a, b) => {
    let aValue = getProperty(a, sortKey, "");
    let bValue = getProperty(b, sortKey, "");
    return aValue.localeCompare(bValue);
  });
  
  return nodeArray;
}

function getProperty(obj, propertyName, defaultValue) {
  if (obj.hasOwnProperty(obj, propertyName) && obj[propertyName]) {
    return obj[propertyName];
  } else {
    return defaultValue;
  }
}

Array.prototype.equals = function (array) {
  if (!array)  return false; 
  if (this.length != array.length) {  console.log('in here'); return false; }

  for(let i = 0; i < this.length; i++){
    if( this[i]['key'] != array[i]['key'] ) return false
  }
  return true;
}

Object.defineProperty(Array.prototype, "equals", {enumerable: false});
