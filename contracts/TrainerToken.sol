// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract TrainerNFT is ERC721, Ownable {
    enum Stats{ Striking, Grappling, Stamina}
    uint8 constant public MAX_COACHED_FIGHTERS = 8;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    mapping(uint=>uint[]) public coachedFighters;
    mapping (uint => mapping(Stats => uint)) public stats;
    mapping (uint => mapping(uint => uint)) public lastPaidDates;

    constructor() ERC721("TrainerNFT", "TRN") {}

    function buy(uint trainerId,uint fighterId) public payable{
        uint8 coachedFighters = coachedFighters[trainerId].length;
        require(coachedFighters<8, "Coach has too many fighters");
        coachedFighters[trainerId].push(fighterId);
        lastPaidDates[trainerId][fighterId] = block.timestamp;
    }
    function randomStats(uint trainerId) public{
        stats[trainerId][Stats.Striking] = 2;
        stats[trainerId][Stats.Grappling] = 1;
        stats[trainerId][Stats.Stamina] = 1;
    }
    function safeMint(address to) public onlyOwner {
        uint tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        randomStats(tokenId);
        _safeMint(to, tokenId);
    }
    function updateFighters(uint trainerId) public{
        uint256 fighterIdLength = coachedFighters[trainerId].length;
        for(uint8 i=0; i<fighterIdLength; i++){
            //if(lastPaidDates[trainerId]
        }
    }
    function removeNoOrder(uint index) public{
        //data[index] = data[data.length - 1];
        //data.pop();
    }
}