// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract FighterNFT is ERC721, Ownable {
    enum Stats{ Striking, Grappling, Stamina, Health}

    using Counters for Counters.Counter;
    mapping (uint16 => mapping(Stats => uint8)) stats;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("FighterNFT", "FGH") {}

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        stats[tokenId] = randomStats();
        _safeMint(to, tokenId);
    }
    function randomStats() public returns(uint256[]){
        uint256[] temp;
        temp[Stats.Striking] = 5;
        temp[Stats.Health] = 3;
        temp[Stats.Stamina] = 4;
        temp[Stats.Grappling] = 9;
        return temp;
    }
    function getStats(uin16 id) public returns (uint256[]){
        return stats[id];
    }
}