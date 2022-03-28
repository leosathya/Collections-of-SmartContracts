// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract MultiSigWallet{
    // events
    event Deposite(address indexed sender, uint amount);
    event Submit(uint indexed txId);
    event Approve(address indexed owner, uint indexed txId);
    event Revoke(address indexed owner, uint indexed txId);
    event Execute(uint indexed txId);

    // State Variables
    struct Transaction{
        address to;
        uint value;
        bytes data;
        bool executed;
    }
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint public reqConfirmation;

    Transaction[] public transactions;
    mapping(uint => mapping(address => bool)) public approved;

    // Modifiers
    modifier onlyOwner{
        require(isOwner[msg.sender], "Only Owner can use this feature.");
        _;
    }
    modifier txExists(uint _txId){
        require(_txId < transactions.length, "Invalide transaction id.");
        _;
    }
    modifier notApproved(uint _txId){
        require(!approved[_txId][msg.sender], "transactionId already approved.");
        _;
    }
    modifier notExecuted(uint _txId){
        require(!transactions[_txId].executed, "trasaction already Executed.");
        _;
    }

    // Functions

    constructor(address[] memory _owners, uint _reqConfirmation){
        uint len = _owners.length;
        require(len > 0, "Owners not Avalable");
        require(_reqConfirmation > 0 && _reqConfirmation <= len, "Invalide required number of Owners");

        for(uint i; i<len; i++){
            address owner = _owners[i];
            require(owner != address(0), "Invalide Owner");
            require(!isOwner[owner], "Owner is not Unique");
            owners.push(owner);
            isOwner[owner] = true;
        }
    }

    receive() external payable{
        emit Deposite(msg.sender, msg.value);
    }

    function submit(address _to, uint _value, bytes calldata _data) external onlyOwner {
        
        transactions.push(Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed: false
        }));

        emit Submit(transactions.length - 1);
    }

    function approve(uint _txId) external onlyOwner txExists(_txId) notApproved(_txId) notExecuted(_txId) {
        approved[_txId][msg.sender] = true;
        emit Approve(msg.sender, _txId);
    }

    function _getApprovalCount(uint _txId) private view returns(uint count){
        for(uint i; i<owners.length; i++){
            if(approved[_txId][owners[i]]){
                count++;
            }
        }
        // here no need to return because explicitly count returned in returns
    }

    function execute(uint _txId) external onlyOwner txExists(_txId) notExecuted(_txId){
        require(_getApprovalCount(_txId) >= reqConfirmation, "Need more Approvals");

        Transaction storage transaction = transactions[_txId];
        transaction.executed = true;
        (bool success, ) = transaction.to.call{value: transaction.value}(
            transaction.data
        );
        require(success, "transaction failed");

        emit Execute(_txId);
    }

    function revoke(uint _txId) external onlyOwner txExists(_txId) notExecuted(_txId){
        require(approved[_txId][msg.sender], "Your have no writes to this feature");
        approved[_txId][msg.sender] = false;
        emit Revoke(msg.sender, _txId);
    }
}