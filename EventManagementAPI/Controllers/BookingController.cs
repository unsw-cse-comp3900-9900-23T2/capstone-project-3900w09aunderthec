﻿using Microsoft.AspNetCore.Mvc;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using EventManagementAPI.DTOs;
using System.Net;
using EventManagementAPI.Services;
using System.Text;
using Org.BouncyCastle.Cms;
using System;

namespace EventManagementAPI.Controllers
{
    public class MakeBookingRequestBody
    {
        // public string email { get; set; }
        public int customerId { get; set; }
        public int ticketId { get; set; }
        public int numberOfTickets { get; set; }
        public int paymentMethod { get; set; }
    };

    public class CancelBookingRequestBody
    {
        public int bookingId { get; set; }
    }

    [ApiController]
    [Route("api/[controller]")]
    public class BookingController : ControllerBase
    {
        private readonly IBookingRepository _bookingRepository;
        private readonly EmailService _emailService;

        public BookingController(IBookingRepository bookingRepository, EmailService emailService)
        {
            _bookingRepository = bookingRepository;
            _emailService = emailService;
        }

        [HttpGet("GetBookings/{uid}")]
        public async Task<IActionResult> GetCustomerBookings(int uid)
        {
            var bookings = await _bookingRepository.GetBookings(uid);

            return Ok(bookings);
        }

        [HttpPost("GetCreditMoney")]
        public async Task<IActionResult> GetCreditMoney([FromQuery] int customerId, [FromQuery] int hosterId)
        {
            var creditAmount = await _bookingRepository.GetCreditMoney(customerId, hosterId);
            if (creditAmount == null)
            {
                return NotFound();
            }

            return Ok(creditAmount);
        }

        [HttpPost("MakeBooking")]
        public async Task<IActionResult> MakeBooking([FromBody] MakeBookingRequestBody RequestBody)
        {

            var customerId = RequestBody.customerId;
            var ticketId = RequestBody.ticketId;
            var numberOfTickets = RequestBody.numberOfTickets;
            var paymentMethod = RequestBody.paymentMethod;

            var booking = await _bookingRepository.MakeBooking(customerId, ticketId, numberOfTickets, paymentMethod);

            if (booking == null)
            {
                return NotFound();
            }

            var totalPriceInt = Convert.ToInt32(booking.toTicket.price * numberOfTickets);
            booking.toCustomer.loyaltyPoints += totalPriceInt * 10;

            var fromAddress = "underthecsharp@outlook.com";
            var toAddress = booking.toCustomer.email;
            var subject = "Booking Confirmed!";
            var body = new StringBuilder()
                .AppendLine("Dear Customer, ")
                .AppendLine("")
                .AppendLine("Your booking has been successful")
                .AppendLine("")
                .AppendLine("Kind Regards,")
                .AppendLine("Under the C")
                .ToString();

            _emailService.SendEmail(fromAddress, toAddress, subject, body);

            return Ok(booking);
        }

        [HttpGet("GetBookingDetails/{bookingId}")]
        public async Task<IActionResult> ShowBookingDetails(int bookingId)
        {
            var b = await _bookingRepository.GetBookingById(bookingId);

            if (b == null)
            {
                return NotFound();
            }

            return Ok(b);
        }

        [HttpDelete("CancelBooking")]
        public async Task<IActionResult> CancelBooking([FromBody] CancelBookingRequestBody RequestBody)
        {
            var booking = await _bookingRepository.GetBookingById(RequestBody.bookingId);

            if (booking == null)
            {
                return NotFound("BookingId does not refer to a valid booking");
            }

            var timeDifference = await _bookingRepository.GetTimeDifference(booking);

            if (timeDifference == null)
            {
                return NotFound("Bookings do not refer to a valid time difference");
            }

            TimeSpan timeDiff = timeDifference.GetValueOrDefault();

            if (timeDiff.TotalDays < 7)
            {
                return BadRequest("Cancellation requests must be made at least 7 days prior to the event.");
            }

            var isDirectRefund = await _bookingRepository.IsDirectRefunds(RequestBody.bookingId);

            if (!isDirectRefund.HasValue)
            {
                return NotFound("There is no refund policy of the event");
            }

            if (isDirectRefund == false)
            {
                var noDirectCancelBooking = await _bookingRepository.NoDirectCancelBooking(RequestBody.bookingId);

                if (noDirectCancelBooking == null)
                {
                    return NotFound();
                }

                return Ok(noDirectCancelBooking);
            }

            var canceledBooking = await _bookingRepository.RemoveBooking(RequestBody.bookingId);

            if (canceledBooking == null)
            {
                return NotFound("Booking to be cancelled not found");
            }

            return Ok(canceledBooking);
        }
    }
}
