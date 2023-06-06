pragma solidity >=0.8.0 <0.9.0;
// SPDX-License-Identifier: MIT

import '@openzeppelin/contracts/access/Ownable.sol';
import './YourToken.sol';
import 'hardhat/console.sol';

contract Vendor is Ownable {
  YourToken public yourToken;

  uint256 public constant tokensPerEth = 100;
  event BuyTokens(address buyer, uint256 amountOfEth, uint256 amountOfTokens);

  constructor(address tokenAddress) public {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
  function buyTokens() public payable {
    // convert msg.value (wei) to ethers
    console.log('msg.value', msg.value);
    console.log('tokensPerEth', tokensPerEth);
    uint256 amountOfTokens = msg.value * tokensPerEth;
    console.log('sending this amount of tokens', amountOfTokens);
    // transfer tokens to buyer
    yourToken.transfer(msg.sender, amountOfTokens);
    emit BuyTokens(msg.sender, msg.value, amountOfTokens);
  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function widthdraw() public onlyOwner {
    // send all the ether that the vendor contract currently owns

    (bool sent, bytes memory data) = msg.sender.call{value: (address(this).balance)}('');
    require(sent, 'Failed to send Ether');
  }

  // ToDo: create a sellTokens() function:
  function sellTokens() public {}
}

// TODO: when you're back, deploy new contract, and see the output of the msg.value console log
