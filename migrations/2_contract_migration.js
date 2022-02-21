var whone = artifacts.require('Whone');
var interview = artifacts.require('Interiew');

module.exports = function (deployer) {
  deployer.deploy(whone);
  deployer.deploy(interview);
};
