const CryptoBird = artifacts.require("CryptoBird");

module.exports = function(deployer) {
    deployer.deploy(CryptoBird);
}