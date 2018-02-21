pragma solidity ^0.4.16;

import 'zeppelin-solidity/contracts/token/MintableToken.sol';

contract InterestToken is MintableToken {

   // round (total, residual)
   struct round {
      uint256 total;
      uint256 residual;
   }

   // rounds
   mapping(uint => round) public rounds;

   // current round
   uint public currentRound;

   // interest received
   mapping(uint => mapping(address => bool)) interestReceived;

   // update interest
   modifier updateInterest(address _to) {
      if (depositInterestOccured()) {
         ReceiveInterest(msg.sender);
         ReceiveInterest(_to);
      }
   _;
   }

   // receive interest
   function ReceiveInterest(address _receiver) public returns(bool) {

      // is there already an interest deposit
      if (depositInterestOccured())
         return;

      // does receiver already received interest this round
      require(interestReceived[currentRound][receiver] == false);

      address receiver = (_receiver != 0) ? _receiver : msg.sender;

      // calulate interest in wei
      uint256 interest = (rounds[currentRound].total * balances[msg.sender]) / totalSupply;

      // sent interest in wei
      receiver.transfer(interest);

      // substract interest of residual of current round
      rounds[currentRound].residual = rounds[currentRound].residual.sub(interest);

      // receiver has received interest this round
      interestReceived[currentRound][receiver] = true;
      return true;
   }

   // deposit interest
   function depositInterest() onlyOwner public payable returns(bool) {

      require(msg.value > 0);

      // new quarter
      require(now >= currentRound + 90 days);

      uint timestamp = now;
      rounds[timestamp].total = msg.value;
      rounds[timestamp].residual = msg.value;
      currentRound = timestamp;
      return true;
   }

   // transfer
   function transfer(address _to, uint256 _value) updateInterest(_to) public returns (bool) {
      super.transfer(_to, _value);
   }

   // has interest deposit occured
   function depositInterestOccured() internal view returns(bool) {
      return rounds[currentRound].total > 0;
   }

}
