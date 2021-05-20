// SPDX-License-Identifier: MIT
// CHANGE LICENSE LATER. JUST PUTTING THIS HERE TO GET RID OF STUPID WARNING

pragma solidity ^0.8.0;
import "./TicketCustomization.sol";

/// @dev THIS CONTRACT WILL BE WORKED LATER FOR EXTRA FEATURES
///
/// @dev This contract provides alternate ways for the contract owner to add customization to tickets. Some ideas are:
/// @dev 1. Randomly select ticket owner(s) to get random customization(s)
/// @dev 2. Everyone on game day gets a basic customization - would need to make sure this doesn't collide with ability to purchase other customizations as right now a ticket can only support 1. Buying would overwrite this gifted one.
/// @dev 3. Raffle. People can send ether into the contract for a chance to win a rare customization. How much ether they put in relative to the other participants at drawing time determines their odds of winning.
contract SpecialCustomizations is TicketCustomization {
   
}