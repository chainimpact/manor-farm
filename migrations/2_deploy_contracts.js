var Animal = artifacts.require("Animal");

// module.exports = function(deployer) {
//   deployer.deploy(Animal);
// };

module.exports = function(deployer) {
    var payload =  ["spotty","0xca35b7d915458ef540ade6068dfe2f44e8fa733c","0x323031303130303131323030","0","dog","terrier","black","0xca35b7d915458ef540ade6068dfe2f44e8fa733c","0xca35b7d915458ef540ade6068dfe2f44e8fa733c","ab123","ab123"]
    deployer.deploy(Animal, "spotty","0xca35b7d915458ef540ade6068dfe2f44e8fa733c","0x323031303130303131323030","0","dog","terrier","black","0xca35b7d915458ef540ade6068dfe2f44e8fa733c","0xca35b7d915458ef540ade6068dfe2f44e8fa733c","ab123","ab123");
};
