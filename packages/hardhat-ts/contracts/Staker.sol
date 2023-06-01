pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import 'hardhat/console.sol';
import './ExampleExternalContract.sol';

contract Staker {
  ExampleExternalContract public exampleExternalContract;

  constructor(address exampleExternalContractAddress) {
    exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  modifier notCompleted() {
    require(exampleExternalContract.completed() == false, 'This fundraiser has not been completed');
    _;
  }

  modifier deadlineMet() {
    require(block.timestamp > deadline, 'Deadline not met');
    _;
  }

  event Stake(address from, uint256 amount);
  mapping(address => uint256) public balances;
  uint256 public constant threshold = 1 ether;
  uint256 public deadline = block.timestamp + 72 hours;
  bool public openForWidthdraw = false;

  function stake() public payable notCompleted {
    require(block.timestamp < deadline, 'Staking has closed');
    emit Stake(msg.sender, msg.value);
    balances[msg.sender] += msg.value;
  }

  function execute() public deadlineMet {
    if (address(this).balance > threshold) {
      exampleExternalContract.complete{value: address(this).balance}();
    }
    openForWidthdraw = true;
  }

  function withdraw() public {
    require(openForWidthdraw == true, 'not open for widthdraw');
    console.log('balances[msg.sender]', balances[msg.sender]);
    uint256 amt = balances[msg.sender];
    balances[msg.sender] = 0;
    (bool sent, ) = msg.sender.call{value: amt}('');
    require(sent, 'Failed to send Ether');
  }

  function timeLeft() public view returns (uint256) {
    if (block.timestamp >= deadline) {
      return 0;
    }
    return deadline - block.timestamp;
  }

  receive() external payable {
    stake();
  }
}
