// SPDX-License-Identifier: MIT
// CHANGE LICENSE LATER. JUST PUTTING THIS HERE TO GET RID OF STUPID WARNING

pragma solidity ^0.8.0;
import "./TicketFactory.sol";

/// @dev Might need to update the logic later to account for users selling their NFTs to others. But I think I might stick to just adding NFTs and not being able to undo it...you can sell the whole ticket with the customization.
/// @dev Maybe add a child contract which allows for other ways to add customization e.g. contract owner randomly selects a ticket to gift a tokenURI to
contract TicketCustomization is ticketFactory {
   mapping(uint16 => address) public tokenURIToOwner;
   mapping(uint16 => uint256) public tokenURIToPrice;
   mapping(uint16 => bool) public tokenURIExists;

   /// @dev Allows customer to buy customization for their ticket which adds a non-zero tokenURI to the ticket structure
   function buyCustomization(uint256 ticketId_, uint16 tokenURI_) public payable {
      require(tokenURIAvailable(tokenURI_), "Sorry, this customization is not available");   // make sure this URI exists and has not been purchased
      require(msg.sender == ticketToOwner[ticketId_]);   // check for ownership of ticket. Possibly could allow approval for other users to buy on their half, but for now we'll leave that out of scope
      require(msg.value >= tokenURIToPrice[tokenURI_]);  // make sure they've sent enough funds
      _addCustomization(ticketId_, tokenURI_);
   }

   /// @dev Changes tokenURI of ticket to non-zero value to add customization
   function _addCustomization(uint256 ticketId_, uint16 tokenURI_) internal {
      tickets[ticketId_].tokenURI = tokenURI_;
   }

   /// @dev This allows the owner of the contract to add token URIs available for purchase. There may have to be some checks in the front end app to make sure they didn't just add URI numbers that don't actually lead to a JSON.
   function _createCustomization(uint16[] memory tokenURIs_) internal onlyOwner {
      for(uint256 i=0; i < tokenURIs_.length; i++) {
         tokenURIExists[tokenURIs_[i]] = true;
      }
   }

   /// @dev Allows the contract owner to set the price of a URI
   function _setPrice(uint16 tokenURI_, uint256 price_) internal onlyOwner {
      tokenURIToPrice[tokenURI_] = price_;
   }

   /// @dev Allows the contract owner to set the price of multiple URI
   function _setPrice(uint16[] memory tokenURIs_, uint256[] memory prices_) internal onlyOwner {
      require(tokenURIs_.length > 0);
      require(tokenURIs_.length == prices_.length || prices_.length == 1);
      if(prices_.length == 1) {
         for(uint256 i=0; i < tokenURIs_.length; i++) {
            _setPrice(tokenURIs_[i], prices_[0]);
         }
      } else {
         for(uint256 i=0; i < tokenURIs_.length; i++) {
            _setPrice(tokenURIs_[i], prices_[i]);
         }
      }
   }

   /// @dev Finds if the tokenURI is available for purchase
   function tokenURIAvailable(uint16 tokenURI_) public view returns (bool) {
      return (tokenURIExists[tokenURI_] && tokenURIToOwner[tokenURI_] == address(0));  // the tokenURI must have been created by the contract owner and it must not already belong to another address
   }
}