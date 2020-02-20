const General = artifacts.require("General");

module.exports = function(deployer) {
  deployer.deploy(General);
};
