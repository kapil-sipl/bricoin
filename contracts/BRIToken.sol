pragma solidity ^0.4.16;

import './InterestToken.sol';

contract BRIToken is InterestToken {

   string public constant name = 'BRI Token';
   string public constant symbol = 'BRI';
   uint8 public constant decimals = 18;

}
