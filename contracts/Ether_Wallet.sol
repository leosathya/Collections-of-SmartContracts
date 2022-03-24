// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Ether_Wallet{
    address public owner;
    modifier onlyOwner{
        require(msg.sender == owner, "Only owner can call this.");
        _;
    }

    constructor(){
        owner = msg.sender;
    }

    receive() payable external{}

    function getBalance() external view onlyOwner returns(uint){
        return address(this).balance / (1 ether);
    }

    function withdrawAll() external onlyOwner{
        payable(owner).transfer(address(this).balance);
    } 

    function withdrawAmount(uint _amount) external onlyOwner{
        uint _balance = address(this).balance / (1 ether);
        require(_amount <= _balance, "Invalid Amount");
        payable(owner).transfer(_amount * (1 ether));
    }
}