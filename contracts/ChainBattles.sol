// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage  {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(uint256 => Warrior) public tokenIdToWarrior;

    constructor() ERC721 ("Chain Battles", "CBTLS"){
    }

struct Warrior { 
   uint256 Level;
   uint256 Strenght;
   uint256 Life;
   uint256 Speed;
}

function generateCharacter(uint256 tokenId) public returns(string memory){

    bytes memory svg = abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
        '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
        '<rect width="100%" height="100%" fill="black" />',
        '<text x="50%" y="20%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",getLevels(tokenId),'</text>',
        '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Strenght: ",getStrenght(tokenId),'</text>',
        '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Life: ",getLife(tokenId),'</text>',
        '<text x="50%" y="80%" class="base" dominant-baseline="middle" text-anchor="middle">', "Speed: ",getSpeed(tokenId),'</text>',
        '</svg>'
    );
    return string(
        abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(svg)
        )    
    );
}

function getLevels(uint256 tokenId) public view returns (string memory) {
    uint256 levels = tokenIdToWarrior[tokenId].Level;
    return levels.toString();
}

function getStrenght(uint256 tokenId) public view returns (string memory) {
    uint256 levels = tokenIdToWarrior[tokenId].Strenght;
    return levels.toString();
}

function getLife(uint256 tokenId) public view returns (string memory) {
    uint256 levels = tokenIdToWarrior[tokenId].Life;
    return levels.toString();
}

function getSpeed(uint256 tokenId) public view returns (string memory) {
    uint256 levels = tokenIdToWarrior[tokenId].Speed;
    return levels.toString();
}

function getTokenURI(uint256 tokenId) public returns (string memory){
    bytes memory dataURI = abi.encodePacked(
        '{',
            '"name": "Chain Battles #', tokenId.toString(), '",',
            '"description": "Battles on chain",',
            '"image": "', generateCharacter(tokenId), '"',
        '}'
    );
    return string(
        abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(dataURI)
        )
    );
}

function mint() public {
    _tokenIds.increment();
    uint256 newItemId = _tokenIds.current();
    _safeMint(msg.sender, newItemId);
    tokenIdToWarrior[newItemId] = Warrior(0,0,5,0);
    _setTokenURI(newItemId, getTokenURI(newItemId));
}

 function train(uint256 tokenId) public {
   require(_exists(tokenId));
   require(ownerOf(tokenId) == msg.sender, "You must own this NFT to train it!");
   uint256 currentLevel = tokenIdToWarrior[tokenId].Level;
   tokenIdToWarrior[tokenId].Level = currentLevel + 1;
   //uint256 currentLevel = tokenIdToWarrior[tokenId].Level;
   //tokenIdToWarrior[tokenId].Level = currentLevel + 1;
   //uint256 currentLevel = tokenIdToWarrior[tokenId].Level;
   //tokenIdToWarrior[tokenId].Level = currentLevel + 1;
   //uint256 currentLevel = tokenIdToWarrior[tokenId].Level;
   //tokenIdToWarrior[tokenId].Level = currentLevel + 1;
   _setTokenURI(tokenId, getTokenURI(tokenId));
}
}