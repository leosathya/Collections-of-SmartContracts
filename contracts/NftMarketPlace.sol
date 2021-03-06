// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openseppelin/contracts/security/ReentrancyGuard.sol";

contract NftMarketPlace is ReentrancyGuard{
    address payable public immutable feeAccount;
    uint public immutable feePercentage;
    uint public itemCount; 

    struct Item{
        uint itemId;
        IERC721 nft;
        uint tokenId;
        uint price;
        address payable seller;
        bool sold;
    }

    event Offered(
        uint itemId,
        address indexed nft,
        uint tokenId,
        uint price,
        address indexed seller
    );

    mapping(uint => Item) public items;

    constructor(uint _feePercentage){
        feeAccount = payable(msg.sender);
        feePercentage = _feePercentage;
    }

    function makeItem(IERC721 _nft, uint _tokenId, uint _price) external nonReentrant{
        require(_price > 0, "Price can't be zero.");
        itemCount++;
        _nft.transferFrom(msg.sender, address(this), _tokenId);
        items[itemCount] = Item(
            itemCount,
            _nft,
            _tokenId,
            _price,
            payable(msg.sender),
            false
        )

        emit Offered(itemCount, address(_nft), _tokenId, _price, msg.sender);
    }
}