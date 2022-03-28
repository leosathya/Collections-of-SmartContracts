// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.5/contracts/utils/cryptography/ECDSA.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.5/contracts/security/ReentrancyGuard.sol";

contract UniDirectionalPaymentGateway is ReentrancyGuard{
    using ECDSA for bytes32;

    address payable public sender;
    address payable public receiver;

    uint private constant DURATION = 3*24*60*60;
    uint public expiresAt;

    constructor(address payable _receiver) payable {
        require(_receiver != address(0), "Invalide receiver.");
        receiver = _receiver;
        sender = payable(msg.sender);
        expiresAt = block.timestamp + DURATION;
    }
    function _getHash(uint _amount) private view returns(bytes32) {
        return keccak256(abi.encodePacked(address(this), _amount)); // sign with address of this contract
                                                                   // to protect agains replay attack on other contracts.
    }
    function _getEthSignHash(uint _amount) private view returns(bytes32) {
        return _getHash(_amount).toEthSignedMessageHash();
    }
    function _varify(uint _amount, bytes memory _sig) private view returns(bool) {
        return _getEthSignHash(_amount).recover(_sig) == sender;
    }
    function getHash(uint _amount) external view returns(bytes32){
        return _getHash(_amount);
    }
    function getEthSignHash(uint _amount) external view returns(bytes32){
        return _getEthSignHash(_amount);
    }
    function varify(uint _amount, bytes memory _sig) external view returns(bool){
        return _varify(_amount, _sig);
    }
    function close(uint _amount, bytes memory _sig) external nonReentrant{
        require(msg.sender == receiver, "Not Valid receiver.");
        require(_varify(_amount, _sig), "Invalide signature");

        (bool sent, ) = receiver.call{value: _amount}("");
        require(sent, "Transaction failed.");
        selfdestruct(sender);
    }
    function cancel() external{
        require(msg.sender == sender, "Only Sender can call this");
        require(block.timestamp >= expiresAt, "Not expired.");
        selfdestruct(sender);
    }
}