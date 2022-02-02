const API_KEY = 'REPLACE_ME_GMAPS_KEY';
const url = new URL('https://maps.googleapis.com/maps/api/geocode/json')

export async function lookupLatLong(location){
  let params = {
    address: `${location.city}`,
    key: API_KEY,
    region: location.country.toLowerCase()
  }
  url.search = new URLSearchParams(params);

  const response = await fetch(url);
  let status = await response.status;
  if(status === 200) {
    let locations = await response.json();
    return locations.results[0].geometry.location;
  }
  else{
    return response.statusText;
  }
}

export async function nodesLatLong(uniqueLocations){
  const locMap = new Map();
  for(let i in uniqueLocations){
    let tempLatLong = await lookupLatLong(uniqueLocations[i]);
    locMap.set(
      `${uniqueLocations[i].city}${uniqueLocations[i].country}`, 
      {
        lat: tempLatLong.lat, 
        lng: tempLatLong.lng
      } 
    )
  }
  return locMap;
}