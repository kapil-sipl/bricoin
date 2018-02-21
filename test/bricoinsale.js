var bricoinsale = artifacts.require("./BRICoinsale.sol");
var FDMToken = artifacts.require("./BRIToken.sol");

contract('bricoinsale', function(accounts) {

   it("should put 30000000 FDM in the first account", function() {
      return bricoinsale.deployed().then(function(instance) {
         return instance.token.call();
      }).then(function(address) {
         return FDMToken.at(address);
      }).then(function(tokenInstance) {
         return tokenInstance.balanceOf.call('0xbAeD4336925A948BA9f60Ee1ffBb5D43BD62967D');
      }).then(function(balance) {
         assert.equal(balance.valueOf(), 3000000, "3000000 wasn't in the first account");
      });
   });

   it("should transfer FDM correctly", function() {

      var token;

      var accountOne = '0xbAeD4336925A948BA9f60Ee1ffBb5D43BD62967D';
      var accountTwo = '0xbAeD4336925A948BA9f60Ee1ffBb5D43BD62967D';

      var accountOneStartBalance;
      var accountTwoStartBalance;
      var accountOneEndBalance;
      var accountTwoEndBalance;

      var amount = 1000;

      return bricoinsale.deployed().then(function(instance) {
         return instance.token.call();
      }).then(function(address) {
         return FDMToken.at(address);
      }).then(function(instance) {
         token = instance;
         return token.balanceOf.call(accountOne);
      }).then(function(balance) {
         accountOneStartBalance = balance.toNumber();
         return token.balanceOf.call(accountTwo);
      }).then(function(balance) {
         accountTwoStartBalance = balance.toNumber();
         return token.transfer(accountTwo, amount, {from: accountOne});
      }).then(function() {
         return token.balanceOf.call(accountOne);
      }).then(function(balance) {
         accountOneEndBalance = balance.toNumber();
         return token.balanceOf.call(accountTwo);
      }).then(function(balance) {
         accountTwoEndBalance = balance.toNumber();
         assert.equal(accountOneEndBalance, accountOneStartBalance - amount, "Amount wasn't correctly taken from the sender");
         assert.equal(accountTwoEndBalance, accountTwoStartBalance + amount, "Amount wasn't correctly sent to the receiver");
      });

   });

   it("should sell FDM tokens correctly", function() {
      
   });

});
