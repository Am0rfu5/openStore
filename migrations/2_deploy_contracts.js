var Store = artifacts.require("./Store.sol");
module.exports = function(deployer) {
  deployer.deploy(Store, ['Eminem', 'Indila', 'Beatles'], ['Sriram', 'Prem', 'Maneesh', 'Goutham', 'Bharath', 'Venky', 'Ravi'], [1000,1000,1000,1000,1000,1000,1000,1000,1000,1000]);
};
