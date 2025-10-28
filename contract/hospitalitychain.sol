// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HospitalityChain {
    struct Booking {
        address guest;
        string hotelName;
        uint256 checkInDate;
        uint256 checkOutDate;
        uint256 amountPaid;
        bool confirmed;
    }

    address public owner;
    uint256 public bookingCount;
    mapping(uint256 => Booking) public bookings;

    event BookingCreated(uint256 bookingId, address guest, string hotelName);
    event BookingConfirmed(uint256 bookingId, bool confirmed);
    event PaymentReceived(address from, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    // 1️⃣ Create a new hotel booking
    function createBooking(
        string memory _hotelName,
        uint256 _checkInDate,
        uint256 _checkOutDate
    ) public payable {
        require(msg.value > 0, "Payment required for booking");

        bookingCount++;
        bookings[bookingCount] = Booking(
            msg.sender,
            _hotelName,
            _checkInDate,
            _checkOutDate,
            msg.value,
            false
        );

        emit PaymentReceived(msg.sender, msg.value);
        emit BookingCreated(bookingCount, msg.sender, _hotelName);
    }

    // 2️⃣ Confirm booking (only owner)
    function confirmBooking(uint256 _bookingId) public {
        require(msg.sender == owner, "Only owner can confirm booking");
        require(!bookings[_bookingId].confirmed, "Already confirmed");

        bookings[_bookingId].confirmed = true;
        emit BookingConfirmed(_bookingId, true);
    }

    // 3️⃣ Withdraw funds (only owner)
    function withdrawFunds() public {
        require(msg.sender == owner, "Only owner can withdraw funds");
        payable(owner).transfer(address(this).balance);
    }

    // View total contract balance
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

