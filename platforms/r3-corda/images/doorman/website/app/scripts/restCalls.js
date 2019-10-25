import {checkToken} from 'scripts/jwtProcess';

const url = document.baseURI;

export async function login(loginData){
  const response = await fetch(`${url}/admin/api/login`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(loginData)
  });
  let status = await response.status;
  if(status === 200) {
    sessionStorage["AccessToken"] = await response.text();
  }
  else{
    console.log(response);
  }
  return response;
}

export async function checkAuth(){
  let status = 403
  const token = sessionStorage['AccessToken'];
  if(token && checkToken(token)){
    status = 200;
  }
  return status;
}

export async function getNodes() {
  const token = sessionStorage["AccessToken"];
  const response = await fetch(`${url}/admin/api/nodes`,{
    method: 'GET',
    headers: {
      'accept': 'application/json',
      "Authorization": `Bearer ${token}`
    }
  })
  let nodes = await response.json();
  return nodes;
}

export async function getNotaries() {
  const response = await fetch(`${url}/admin/api/notaries`,{
    method: 'GET',
    headers: {
      'accept': 'application/json',
      "Authorization": `Bearer ${sessionStorage["AccessToken"]}`
    }
  })
  let notaries = await response.json();
  return notaries;
}

export async function getBraidAPI(){
  const response = await fetch(`${url}/braid/api`,{
    method: 'GET',
    headers: {
      'accept': 'application/json',
      "Authorization": `Bearer ${sessionStorage["AccessToken"]}`
    }
  })
  let braidCode = await response.json();
  return braidCode;
}

export async function deleteNodes(nodeKey){
  const response = await fetch(`${url}/admin/api/nodes/${nodeKey}`, 
    {
      method: 'DELETE',
      headers: {
        'accept': 'application/json',
        "Authorization": `Bearer ${sessionStorage["AccessToken"]}`
      }
    });
    return response;
}

