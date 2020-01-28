//Parses info from string in format OU=OrganizationUnit,O=Organization,L=Lat/Long/City,C=Country

function getOrganization(name) {
  return(name.split('O=')[1].split(',')[0]);
};
function getLocation (name) {
  //return(name.split('L=')[1].split(',')[0]);
  return(name.split('L=')[1].split('/')[2].split(',')[0]);
};
function getLongitude(name){
  return(name.split('L=')[1].split('/')[1].split(',')[0]);
}
function getLatitude(name){
  return(name.split('L=')[1].split('/')[0].split(',')[0]);
}
function getCountry (name) {
  return(name.split('C=')[1].split(',')[0]);
};
function getOrganizationUnit(name){
  if (name.includes("+OU=")) {  //Fabric adds additional OU, hence +OU check
    const lower = name.split('+OU=')[1].split(',')[0];
    const upper = lower.charAt(0).toUpperCase() + lower.substring(1);
    return upper;
  } else {
    return(name.split('OU=')[1].split(',')[0]);
  }  
}

export default {
  getOrganization,
  getLocation,
  getLatitude,
  getLongitude,
  getCountry,
  getOrganizationUnit,
};
