//function to take a js time object and extract the Timezone name and make into acryonym
function getTimezone(time){
  let fullTimezone = time.toString().match(/\(([A-Za-z\s].*)\)/)[1];
  let letterArray = []
  for (let word of fullTimezone.split(' ')){
    letterArray.push(word[0]);
  };
  let simplifiedTimezone = letterArray.join("")
  return simplifiedTimezone;
};
export default (getTimezone);
