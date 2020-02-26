const ContainerContract = artifacts.require("ContainerContract");
 
module.exports = function(deployer) {
 deployer.deploy(ContainerContract);
};
