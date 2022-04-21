// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC721Token is Ownable, ERC721{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    using Strings for uint256;

    mapping(uint256 => string) private _tokenURIs;

    string private _baseURIextended;

    constructor() public ERC721("My NFT Collection", "MNC"){}
        function setBaseURI(string memory baseURI_) external onlyOwner{
            _baseURIextended = baseURI_;
        }
        function _setTokenURI(string tokenId, string memory _tokenURI) internal virtual {
            require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
            _tokenURIs[tokenId] = _tokenURI;
        }
        function _baseURI() internal view virtual override returns (string memory){
            return _baseURIextended;
        }
        
    
}