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

    mapping (uint => mapping(Stats => uint)) stats;

    event FightOfferEmit(address from, address to);

    constructor() ERC721("FighterNFT", "FGH") {}

    function safeMint(address to) public onlyOwner {
        uint tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        randomStats(tokenId);
        _safeMint(to, tokenId);
    }
    function randomStats(uint tokenId) public{
        stats[tokenId][Stats.Striking] = 5;
        stats[tokenId][Stats.Health] = 3;
        stats[tokenId][Stats.Stamina] = 4;
        stats[tokenId][Stats.Grappling] = 9;
        stats[tokenId][Stats.PotentialAbility] = 9;
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
            //fight(fighterANFT, fighterBNFT, from, msg.sender);
        }
    }
    function fight(uint aNFT, uint bNFT, address fighterA, address fighterB) private{
        uint combinedStatsA = combinedStats(aNFT);
        uint combinedStatsB = combinedStats(bNFT);

        uint winnerNumber = randomNumber();
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
        //uint randomStats = randomStats();
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
}