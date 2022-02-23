// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './ERC721Connector.sol';

contract CryptoBird is ERC721Connector {

    // NFT list
    string[] public _cryptoBirds;

    mapping(string => bool) _cryptoBirdsExist;

    constructor() ERC721Connector("CryptoBird", "CRYPTOB") public { }

    function mint(string memory bird) public {
        require(!_cryptoBirdsExist[bird], "Error: Cryptobird already exists.");
        
        _cryptoBirds.push(bird);
        uint256 tokenID = _cryptoBirds.length - 1;

        _mint(msg.sender, tokenID);
        _cryptoBirdsExist[bird] = true;
    }

    // function balanceOf(address owner) public view returns(uint256) {
    //     return balanceOf(owner);
    // }

    // function ownerOf(uint256 tokenID) public view returns(address) {
    //     return ownerOf(tokenID);
    // }
}
