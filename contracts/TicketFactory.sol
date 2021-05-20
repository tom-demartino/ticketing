// SPDX-License-Identifier: MIT
// CHANGE LICENSE LATER. JUST PUTTING THIS HERE TO GET RID OF STUPID WARNING

pragma solidity ^0.8.0;

// SafeMath no longer needed as of Solidity 0.8.0 - arithmetic is checked for overflow/underflow and ** is handled in gas-efficient manner for most cases
import "./utils/Ownable.sol";
import "./utils/MyUtils.sol";

contract ticketFactory is Ownable, MyUtils {
    
   uint256 ticketCount;

   struct Ticket {
      string seat;
      uint16 tokenURI;  // value of zero indicates no ticket customization purchased
      uint8 section;
   }

   Ticket[] public tickets;

   mapping (uint256 => address) public ticketToOwner;
   mapping (address => uint256) public ownerTicketCount;

   /// @dev Creates an individual ticket for sale
   function _createTicket(string memory seat_, uint8 section_) internal onlyOwner {
      tickets.push(Ticket(seat_, 0, section_));
   }

   /// @dev Creates a group of tickets for sale. Array of seats and sections must be same length with 1:1 mapping, else sections_[] can be length 1 and that section will apply to all seat numbers.
   function _createTicket(string[] memory seats_, uint8[] memory sections_) internal onlyOwner {
      require(seats_.length > 0);
      require(seats_.length == sections_.length || sections_.length == 1); // each seat is assigned unique section number, or one section number is applied to all seats
      if(sections_.length == 1) {
         for(uint256 i=0; i < seats_.length; i++) {
            _createTicket(seats_[i], sections_[0]);
         }
      } else {
         for(uint256 i=0; i < seats_.length; i++) {
            _createTicket(seats_[i], sections_[i]);
         }
      }
   }

   /// @dev Gets the ticketId for a given seat
   function getTicketId(string memory seat_) public view returns (uint256) {
      for(uint256 i = 0; i < ticketCount; i++) {
         if(isEqual(tickets[i].seat, seat_)) {
               return i;
         }
      }
      revert("Seat does not exist.");
   }

   /// @dev Gets all tickets for address
   function getTicketsForOwner(address owner_) public view returns (uint256[] memory) {
      require(owner_ != address(0));
      uint256[] memory ownedTickets = new uint256[](ownerTicketCount[owner_]);
      uint256 count;
      for(uint256 i=0; i < tickets.length; i++) {
         if(ticketToOwner[i] == owner_) {
            ownedTickets[count] = i;
            count++;
         }
      }
      return ownedTickets;
   }
}