// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface IERC20{
    function totalSupply() external view returns(uint);
    function balanceOf(address account) external view returns(uint);
    function transfer(address recipient, uint amount) external returns(bool);
    //function allowance(address owner, address spender) external view returns(uint);
    function approve(address spender, uint amount) external returns(bool);
    //function transferFrom(address sender, address receiver, uint amount) external returns(bool);

    event Transfer(address indexed from, address indexed to, uint amount);
    event Approval(address indexed owner, address indexed spender, uint amount);
}

contract ERC20Token is IERC20{
    address internal owner;
    uint internal totalTokens;
    string internal constant tokenName = "My Token";
    string internal constant takenSymbol = "MT";
    uint8 internal constant tokenDecimal = 18;

    mapping(address => uint) internal balances;
    mapping(address => mapping(address => uint)) internal allowance;

    // Modifiers
    modifier onlyOwner(){
        require(msg.sender == owner, "Only Owner Can call this feature.");
        _;
    }

    constructor(){
        owner = msg.sender;
    }

    function totalSupply() external view returns(uint){
        return totalTokens;
    }

    function balanceOf(address _account) external view returns(uint){
        return balances[_account];
    }

    function transfer(address _recipient, uint _amount) external returns(bool){
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        emit Transfer(msg.sender, _recipient, _amount);
        return true;
    }

    function approve(address _spender, uint _amount) external onlyOwner returns(bool){
        allowance[msg.sender][_spender] = _amount;  // msg.sender costs less gas than state variable
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    function transferOnBehalfOf(address _sender, address _recipient, uint _amount) external returns(bool){
        allowance[_sender][msg.sender] -= _amount; // always deduct first to avoid Reentrancy Problem
        balances[_sender] -= _amount;
        balances[_recipient] += _amount;
        emit Transfer(_sender, _recipient, _amount);
        return true;
    }

    function mintTokens(uint _amount) external onlyOwner{
        totalTokens += _amount;
        balances[msg.sender] += _amount;
        emit Transfer(address(0), msg.sender, _amount);
    }

    function burnTokens(uint _amount) external {
        totalTokens -= _amount;
        balances[msg.sender] -= _amount;
        emit Transfer(msg.sender, address(0), _amount);
    }
}