// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @dev This may be better used in a library. Then I think it can be used like
/// @dev "using MyStrLib for string;
/// @dev "str1.isEqual(str2)"
abstract contract MyUtils {
    function isEqual(string memory str1_, string memory str2_) public pure virtual returns (bool) {
        return keccak256(abi.encodePacked(str1_)) == keccak256(abi.encodePacked(str2_));
    }
}