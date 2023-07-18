using Microsoft.AspNetCore.Mvc;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using EventManagementAPI.DTOs;
using System.Net;
using EventManagementAPI.Services;
using System.Text;
using Org.BouncyCastle.Cms;
using System;
using System.Net.Mail;

namespace EventManagementAPI.Controllers
{
    public class MakeBookingRequestBody
    {
        // public string email { get; set; }
        public int customerId { get; set; }
        public Dictionary<string, int> bookingTickets { get; set; }
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
            var bookingTickets = RequestBody.bookingTickets;
            var paymentMethod = RequestBody.paymentMethod;

            var booking = await _bookingRepository.MakeBooking(customerId, bookingTickets, paymentMethod);

            if (booking == null)
            {
                return NotFound();
            }

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

            try {
            _emailService.SendEmail(fromAddress, toAddress, subject, body);
            } catch (SmtpException e) {
                return Ok("Booking successful, however the confirmation email failed to be delivered. It may have been rejected by spam filters, or the address may be nonexistent");
            }

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

            var cancelBooking = await _bookingRepository.RemoveBooking(RequestBody.bookingId);

            if (cancelBooking == null)
            {
                return NotFound("Booking to be cancelled failed");
            }

            return Ok(cancelBooking);
        }
    }
}
