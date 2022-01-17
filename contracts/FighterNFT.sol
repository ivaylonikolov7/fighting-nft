// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract FighterNFT is ERC721, Ownable {
    enum Stats{ Striking, Grappling, Stamina, Health, PotentialAbility}
    uint8[] public fightOffer;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    mapping (uint => mapping(Stats => uint)) stats;

    event FightOfferEmit(address from, address to, uint nftA, uint nftB);
    event AcceptFightOffer(uint fightId);

    constructor() ERC721("FighterNFT", "FGH") {}

    function safeMint(address to) public onlyOwner {
        uint tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        randomStats(tokenId);
        _safeMint(to, tokenId);
    }
    function randomStats(uint tokenId) public{
        stats[tokenId][Stats.Striking] = random(10);
        stats[tokenId][Stats.Health] = random(10);
        stats[tokenId][Stats.Stamina] = random(10);
        stats[tokenId][Stats.Grappling] = random(10);
        stats[tokenId][Stats.PotentialAbility] = random(10);
    }
    function getStriking(uint id) public view returns(uint){
        return stats[id][Stats.Striking];
    }
    function getGrappling(uint id) public view returns (uint){
        return stats[id][Stats.Grappling];
    }
    function getStamina(uint id) public view returns (uint){
        return stats[id][Stats.Stamina];
    }
    function getHealth(uint id) public view returns (uint){
        return stats[id][Stats.Health];
    }
    function getPA(uint id) public view returns (uint){
        return stats[id][Stats.PotentialAbility];
    }
    function sendFightOffer(address to, uint nftA, uint nftB) public{
        fightOffer.push(1);
        emit FightOfferEmit(msg.sender,to, nftA, nftB);
    }
    function acceptFightOffer(address from, uint fightId, uint nftA, uint nftB) public{
        fightOffer[fightId]++;
        if(fightOffer[fightId] == 2){
            fight(nftA, nftB, from, msg.sender);
            emit AcceptFightOffer(fightId);
        }
    }
    function fight(uint aNFT, uint bNFT, address fighterA, address fighterB) private{
        uint combinedStatsA = combinedStats(aNFT);
        uint combinedStatsB = combinedStats(bNFT);

        uint winnerNumber = random(combinedStatsA + combinedStatsB);
        if(winnerNumber <= combinedStatsA){
            winner(aNFT);
        }
        else{
            winner(bNFT);
        }
    }

    function randomNumber() public pure returns (uint){
        return 3;
    }
    function winner(uint id) private{
        uint potentialAbility = stats[id][Stats.PotentialAbility];
        if(potentialAbility>0){
            stats[id][Stats.Striking]++;
        }
        stats[id][Stats.Health]--;
        stats[id][Stats.PotentialAbility]--;
    }
    function combinedStats(uint aNFT) public view returns(uint){
        uint grappling = stats[aNFT][Stats.Grappling];
        uint striking = stats[aNFT][Stats.Striking];
        uint stamina = stats[aNFT][Stats.Stamina];

        return grappling + striking + stamina;
    }
    function random(uint a) private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp))) % a;
    } 
}