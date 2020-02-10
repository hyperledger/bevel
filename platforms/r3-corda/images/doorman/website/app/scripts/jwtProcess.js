const getJWTExpiryDate = (token) => {
  let jwtArray = token.split('.');
  let result = JSON.parse(atob(jwtArray[1]));
  return result.exp;
}

export const checkToken = (token) => {
  let unixTime = Date.now();
  return (Math.floor(unixTime/1000) <= getJWTExpiryDate(token));
}