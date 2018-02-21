var HDWalletProvider = require("truffle-hdwallet-provider");

var infura_apikey = "gi1MpaKQdsmBxkPefD2b";
var mnemonic = "fashion moral guess host nephew crime pitch fringe venue medal choose discover";

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    rinkeby: {
      provider: new HDWalletProvider(mnemonic, "https://rinkeby.infura.io/"+infura_apikey),
      network_id: 3
    }
  }
};