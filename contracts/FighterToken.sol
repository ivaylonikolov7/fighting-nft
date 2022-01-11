// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract FighterNFT is ERC721, Ownable {
    enum Stats{ Striking, Grappling, Stamina, Health, PotentialAbility}
    uint8[] fightOffer;
    uint8 fightOfferId;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    mapping (uint256 => mapping(Stats => uint256)) stats;

    event FightOfferEmit(address from, address to);

    constructor() ERC721("FighterNFT", "FGH") {}

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        randomStats(tokenId);
        _safeMint(to, tokenId);
    }
    function randomStats(uint256 tokenId) public{
        stats[tokenId][Stats.Striking] = 5;
        stats[tokenId][Stats.Health] = 3;
        stats[tokenId][Stats.Stamina] = 4;
        stats[tokenId][Stats.Grappling] = 9;
        stats[tokenId][Stats.PotentialAbility] = 9;
    }
    function getFighterStriking(uint256 id) public returns (uint256){
        return stats[id][Stats.Striking];
    }
    function getFighterGrappling(uint256 id) public returns (uint256){
        return stats[id][Stats.Grappling];
    }
    function getFighterStamina(uint256 id) public returns (uint256){
        return stats[id][Stats.Stamina];
    }
    function getFighterHealth(uint256 id) public returns (uint256){
        return stats[id][Stats.Health];
    }
    function getFighterPA(uint256 id) public returns (uint256){
        return stats[id][Stats.PotentialAbility];
    }
    function sendFightOffer(address to) public returns (uint8){
        address from = msg.sender;
        fightOfferId++;
        fightOffer[fightOfferId]++;

        emit FightOfferEmit(from,to);
        return fightOfferId;
    }
    function acceptFightOffer(address from) public{
        fightOffer[fightOfferId]++;
        if(fightOffer[fightOfferId] == 2){
            fight(from, msg.sender);
        }
    }
}