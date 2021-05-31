const USDFToken = artifacts.require("USDFToken");

module.exports = function(deployer) {
  deployer.deploy(USDFToken);
};

//utool migrate --network mainnet --reset

//mainnet -prod - UadoQumZ1WydLWrztMQS59wBRbYWPaTzmT