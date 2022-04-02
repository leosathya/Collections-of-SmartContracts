// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

interface IERC721{
    function transferFrom(address from, address to, uint nftId) external;
}

contract EnglishAuction{
    IERC721 public immutable nft;
    uint public immutable nftId;

    address payable public immutable seller;
    uint32 public endAt;
    bool public started;
    bool public ended;

    address public highestBidder;
    uint public highestBid;

    mapping(address => uint) public bids;

    // Modifiers
    modifier onlySeller(){
        require(msg.sender == seller, "Only seller can call this");
        _;
    }
    modifier isstarted(){
        require(started, "Auction not started");
        _;
    }
    modifier notEnded(){
        require(block.timestamp < endAt, "Auction not ended.");
        _;
    }
    modifier isended(){
        require(ended, "Auction ended.");
        _;
    }

    // Events
    event Start();
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed sender, uint amount);
    event End(address highestBidder, uint highestBid);

    constructor(address _nft, uint _nftId, uint _startPrice){
        nft = IERC721(_nft);
        nftId = _nftId;
        seller = payable(msg.sender);
        highestBid = _startPrice;
    }

    function start() external onlySeller{
        require(!started, "Already Started.");
        started = true;
        endAt = uint32(block.timestamp + 1 days);
        nft.transferFrom(msg.sender, address(this), nftId);

        emit Start();
    }

    function bid() external payable isstarted notEnded{
        require(msg.value > highestBid, "already highest bid exists.");

        if(highestBidder != address(0)){
            bids[highestBidder] += highestBid;
        }
        highestBid = msg.value;
        highestBidder = msg.sender;

        emit Bid(msg.sender, msg.value);
    }

    function withdraw() external {
        uint bal = bids[msg.sender];
        require(bal > 0, "not bided");
        bids[msg.sender] = 0;
        (bool sent, ) = msg.sender.call{value: bal}("");
        require(sent, "Balance not transfered");

        emit Withdraw(msg.sender, bal);
    }

    function end() external isstarted notEnded{
        ended = true;
        if(highestBidder != address(0)){
            nft.transferFrom(address(this), highestBidder, nftId);
            (bool send, ) = seller.call{value: highestBid}("");
            require(send, "Balance not transfered");
        }
        else{
            nft.transferFrom(address(this), seller, nftId);
        }
        emit End(highestBidder, highestBid);
    }
}