// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';

contract ERC721Enumerable is IERC721Enumerable, ERC721 {

    // list of all tokens
    uint256[] private _allTokens;

    // mapping from tokenId to position in _allTokens
    mapping(uint256 => uint256) private _allTokensIndex;

    // mapping of owner to list of all owner token ids
    mapping(address => uint256[]) private _ownedTokens;

    // mapping from tokenId to index of the owners token list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    constructor() public {
        _registerInterface(
            bytes4(
                keccak256('totalSupply(bytes4)')^
                keccak256('tokenByIndex(bytes4)')^
                keccak256('tokenOfOwnerByIndex(bytes4)')
                )
            );
    }

    /// @notice Count NFTs tracked by this contract
    /// @return A count of valid NFTs tracked by this contract, where each one of
    ///  them has an assigned and queryable owner not equal to the zero address
    function totalSupply() external view returns (uint256) {
        return _allTokens.length;
    }

    /// @notice Enumerate valid NFTs
    /// @dev Throws if `_index` >= `totalSupply()`.
    /// @param _index A counter less than `totalSupply()`
    /// @return The token identifier for the `_index`th NFT,
    ///  (sort order not specified)
    function tokenByIndex(uint256 _index) external view returns (uint256) {
        require(_index < _allTokens.length, "Error: Index is out of bound.");
        return _allTokens[_index];
    }

    /// @notice Enumerate NFTs assigned to an owner
    /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
    ///  `_owner` is the zero address, representing invalid NFTs.
    /// @param _owner An address where we are interested in NFTs owned by them
    /// @param _index A counter less than `balanceOf(_owner)`
    /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
    ///   (sort order not specified)
    function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {
        require(_owner != address(0), "Error: invalid address.");
        require(_index < balanceOf(_owner), "Error: index is out of bound.");
        uint256[] memory tokens = _ownedTokens[_owner];
        return tokens[_index];
    }

    function _mint(address to, uint256 tokenID) internal {
        super._mint(to, tokenID);

        // a. add tokens to the owners token enumeration
        _addTokenToOwnerTokenEnumerations(to, tokenID);

        // b. all tokes to our totalSupply - to allTokens
        _addTokenToAllTokensEnumerations(tokenID);
    }
    
    // Adds token to _allTokens list and update it's position to reverse map.
    function _addTokenToAllTokensEnumerations(uint256 tokenID) private {
        _allTokensIndex[tokenID] = _allTokens.length;
        _allTokens.push(tokenID);
    }
    
    // Adds token to _ownerTokens list and update it's position to reverse map.
    function _addTokenToOwnerTokenEnumerations(address owner, uint256 tokenID) private {
        _ownedTokensIndex[tokenID] = _ownedTokens[owner].length;
        _ownedTokens[owner].push(tokenID);
    }
}