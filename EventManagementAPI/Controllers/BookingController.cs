using Microsoft.AspNetCore.Mvc;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using EventManagementAPI.DTOs;
using System.Net;
using EventManagementAPI.Services;
using System.Text;
using Org.BouncyCastle.Cms;

namespace EventManagementAPI.Controllers
{
    public class MakeBookingRequestBody
    {
        // public string email { get; set; }
        public int customerId { get; set; }
        public int ticketId { get; set; }
        public int numberOfTickets { get; set; }
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

        [HttpPost("MakeBooking")]
        public async Task<IActionResult> MakeBooking([FromBody] MakeBookingRequestBody RequestBody)
        {

            var customerId = RequestBody.customerId;
            var ticketId = RequestBody.ticketId;
            var numberOfTickets = RequestBody.numberOfTickets;

            var booking = await _bookingRepository.MakeBooking(customerId, ticketId, numberOfTickets);

            if (booking == null)
            {
                return NotFound();
            }

            return Ok(booking);

            // var fromAddress = "young.jiapeng@outlook.com";
            // var toAddress = RequestBody.email;
            // var subject = "Booking Confirmed!";

            // var body = new StringBuilder()
            //    .AppendLine("Dear Customer,")
            //    .AppendLine("")
            //    .AppendLine("Your booking has been successful")
            //    .AppendLine("")
            //    .AppendLine("Kind Regards,")
            //     .AppendLine("Under the C")
            // .ToString();

            // _emailService.SendEmail(fromAddress, toAddress, subject, body);

            // return Ok();
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
            var booking = await _bookingRepository.RemoveBooking(RequestBody.bookingId);

            if (booking == null)
            {
                return NotFound();
            }

            return Ok(booking);
        }
    }
}
