// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './ERC165.sol';
import './interfaces/IERC721.sol';

/*
Building out the minting functions:
    1. Non-fungible token (NFT) to point to an address.
    2. Keep track of the token ID.
    3. Keep track of token owner addresses to token IDs.
    4. Keep track of how many tokens an owner address has.
    5. Create an event that emits a
        - transfer logs: where it's being minted to and ID
*/

contract ERC721 is ERC165, IERC721 {
    // Owner of the contract
    address private _owner;

    // mapping from token-id to the owners.
    mapping(uint256 => address) private _tokenOwner;

    // mapping from owner to token count.
    mapping(address => uint256) private _ownedTokensCount;

    // mapping for tokenIds to approved addresses
    mapping(uint256 => address) private _tokenApprovals;

    // modifiers:
    modifier ownerOnly() {
        require(
            msg.sender == _owner,
            "This function is restricted to the contract's owner"
        );
        _;
    }

    constructor() public {
        _registerInterface(
            bytes4(
                keccak256('balanceOf(bytes4)')^
                keccak256('ownerOf(bytes4)')^
                keccak256('transferFrom(bytes4)')
                )
            );
    }

    function balanceOf(address owner) public view  returns(uint256) {
        require(owner != address(0), "ERC721: minting to an invalid address.");
        uint256 count = _ownedTokensCount[owner];
        return count;
    }

    function ownerOf(uint256 tokenId) public view  returns(address) {
        require(_exists(tokenId), "ERC721: token is not minted.");

        address owner = _tokenOwner[tokenId];
        return owner;
    }

    function _exists(uint256 tokenId) internal view returns(bool) {
        // setting the address of NFT owner to check the mapping
        // of the address from tokenOwner at tokenId.
        address owner = _tokenOwner[tokenId];

        // return truthiness that address is not invalid.
        return (owner != address(0));
    }

    function _mint(address to, uint256 tokenId) internal {
        require(to != address(0), "ERC721: minting to an invalid address.");
        require(!_exists(tokenId), "ERC721: token is already minted.");

        // bookkeeping
        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }

    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        require(_to != address(0), "ERC721: Error! invalid to address.");
        require(_from != address(0), "ERC721: Error! invalid from address.");
        require(_from == _tokenOwner[_tokenId], "ERC721: Error! Access denied as you are not the token owner.");
        
        require(isApprovedAndOwned(_to, _tokenId), "ERC721: Error! Transfer not approved.");

        _ownedTokensCount[_from] -= 1;
        _ownedTokensCount[_to] += 1;

        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
        _transferFrom(_from, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) public {
        require(_exists(_tokenId), "Error! token does not exist");
        require(_to != address(0), "ERC721: Error! invalid to address.");

        address owner = _tokenOwner[_tokenId];
        require(owner == msg.sender, "ERC721: Error! not the present owner.");
        require(owner == _to, "ERC721: approval to current owner.");

        _tokenApprovals[_tokenId] = _to;

        emit Approval(owner, _to, _tokenId);
    }

    function isApprovedAndOwned(address _to, uint256 _tokenId) internal view returns(bool) {
        require(_exists(_tokenId), "Error! token does not exist");
        require(_to != address(0), "ERC721: Error! invalid to address.");
        return _tokenApprovals[_tokenId] == _to;
    }
}