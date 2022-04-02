// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

interface IERC721{
    function transferFrom(address from, address to, uint tokenId) external;
}

contract DutchAuction{
    uint private constant TIMEPERIOD = 7 days;
    IERC721 public immutable nft;
    uint public immutable nftId;
    address payable public immutable seller;
    uint16 public immutable startingPrice;
    uint16 public immutable discountRate;
    uint public immutable startAt;
    uint public immutable endAt;
    

    constructor(address _nft, uint _nftId, uint16 _startPrice, uint16 _discountRate){
        startingPrice = _startPrice;
        discountRate = _discountRate;
        require(_startPrice >= _discountRate * TIMEPERIOD, "Invalide StartPrice"); // Immutable stateVariable can't call in constructor

        seller = payable(msg.sender);
        nft = IERC721(_nft);
        nftId = _nftId;
        startAt = block.timestamp;
        endAt = block.timestamp + TIMEPERIOD;
    }

    function currPrice() public view returns(uint price){
        uint passedTime = block.timestamp - startAt;
        uint discount = discountRate * passedTime;
        return price = startingPrice - discount;
    }

    function buy() external payable{
        require(block.timestamp < endAt, "Auction already ended.");

        uint price = msg.value;
        uint curPrice = currPrice();
        require(price >= curPrice, "Incorrect value");
        nft.transferFrom(seller, msg.sender, price);
        uint refund = price - curPrice;

        if(refund > 0){
        (bool send, ) = msg.sender.call{value: refund}("");
        require(send, "Refund unable to send.");
        }
   
        selfdestruct(payable(seller));
    }
}