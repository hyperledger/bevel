//function to take an int and check if its single digit and padd with an extra 0 for display as text
function numberPadding(num){
  if (num < 10){
    return `0${num}`;
  }else {
    return `${num}`
  }
};

export default (numberPadding);
