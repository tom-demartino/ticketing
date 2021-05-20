// SPDX-License-Identifier: MIT
// CHANGE LICENSE LATER. JUST PUTTING THIS HERE TO GET RID OF STUPID WARNING

pragma solidity ^0.8.0;

import "./TicketCustomization.sol";
import "./utils/ERC721.sol";

/// @dev tokenId = ticketId. token is semantics for general ERC721, I'm calling it ticket as it fits with context of contract.
/// @dev Need to override a bunch of functions to use my custom mappings from TicketFactory.sol
/// @dev Don't think I need mint or burn functions, may want to implement a _beforeTokenTransfer hook at some point down the road.
contract TicketOwnership is TicketCustomization, ERC721 {
   using Address for address;
   using Strings for uint256;

   constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {}

   /// @dev See {IERC721-balanceOf}.
   function balanceOf(address owner_) public view override returns (uint256) {
      require(owner_ != address(0), "ERC721: balance query for the zero address");
      return ownerTicketCount[owner_];
   }

   /// @dev See {IERC721-ownerOf}.
   function ownerOf(uint256 ticketId_) public view override returns (address) {
      address owner = ticketToOwner[ticketId_];
      require(owner != address(0), "ERC721: owner query for nonexistent token");
      return owner;
   }

   /// @dev See {IERC721Metadata-tokenURI}.
   function tokenURI(uint256 ticketId_) public view override returns (string memory) {
      require(_exists(ticketId_), "ERC721Metadata: URI query for nonexistent token");

      string memory baseURI = _baseURI();
      return bytes(baseURI).length > 0
         ? string(abi.encodePacked(baseURI, uint256(tickets[ticketId_].tokenURI).toString()))
         : '';
   }

   /// @dev Need to update this when I have an actual link to json files.
   /// @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
   /// in child contracts.
   function _baseURI() internal pure override returns (string memory) {
      return "https://<website>.com/<event>/<event_date>/";
   }

   /// @dev Returns whether `ticketId` exists.
   /// 
   /// Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
   /// 
   /// Tokens start existing when they are minted (`_mint`),
   /// and stop existing when they are burned (`_burn`).
   function _exists(uint256 ticketId_) internal view override returns (bool) {
      return ticketToOwner[ticketId_] != address(0);
   }

   /// @dev Transfers `ticketId` from `from` to `to`.
   ///  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
   /// 
   /// Requirements:
   /// 
   /// - `to` cannot be the zero address.
   /// - `ticketId` token must be owned by `from`.
   /// 
   /// Emits a {Transfer} event.
   function _transfer(address from_, address to_, uint256 ticketId_) internal override {
      require(ownerOf(ticketId_) == from_, "ERC721: transfer of token that is not own");
      require(to_ != address(0), "ERC721: transfer to the zero address");

      _beforeTokenTransfer(from_, to_, ticketId_);

      // Clear approvals from the previous owner
      _approve(address(0), ticketId_);

      ownerTicketCount[from_] -= 1;
      ownerTicketCount[to_] += 1;
      ticketToOwner[ticketId_] = to_;

      emit Transfer(from_, to_, ticketId_);
   }
}