pragma solidity ^0.4.18;

import './BRIToken.sol';
import 'zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol';
import 'zeppelin-solidity/contracts/crowdsale/RefundableCrowdsale.sol';

contract bricoinsale is CappedCrowdsale, RefundableCrowdsale {

   function bricoinsale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _goal, uint256 _cap, address _wallet)
      CappedCrowdsale(_cap)
      FinalizableCrowdsale()
      RefundableCrowdsale(_goal)
      Crowdsale(_startTime, _endTime, _rate, _wallet)
      public
   {
      require(_goal <= _cap);

      // 30% influencers (10.000.000 * 0.3)
      token.mint(_wallet, 3000000);

   }

   function createTokenContract() internal returns (MintableToken) {
      return new BRIToken();
   }

   function buyTokens(address beneficiary) public payable {
      require(beneficiary != address(0));
      require(validPurchase());

      uint256 weiAmount = msg.value;

      // calculate token amount to be created
      uint256 tokens = weiAmount.mul(rate);

      // bonus
      if (token.totalSupply() <= 600000) {
         tokens.mul(115).div(100);
      } else if(token.totalSupply() <= 1200000) {
         tokens.mul(110).div(100);
      } else if(token.totalSupply() <= 1800000) {
         tokens.mul(105).div(100);
      }

      // update state
      weiRaised = weiRaised.add(weiAmount);

      token.mint(beneficiary, tokens);
      TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);

      forwardFunds();

   }

}
