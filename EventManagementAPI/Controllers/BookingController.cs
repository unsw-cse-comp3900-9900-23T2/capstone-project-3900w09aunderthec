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
        public string email { get; set; }
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
        private readonly ITicketRepository _ticketRepository;
        private readonly ICustomerRepository _customerRepository;
        private readonly EmailService _emailService;

        public BookingController(IBookingRepository bookingRepository, ITicketRepository ticketRepository, ICustomerRepository customerRepository, EmailService emailService)
        {
            _bookingRepository = bookingRepository;
            _ticketRepository = ticketRepository;
            _customerRepository = customerRepository;
            _emailService = emailService;
        }

        [HttpGet("GetBookings")]
        public async Task<IActionResult> GetCustomerBookings([FromQuery] int uid)
        {
            var bookings = await _bookingRepository.GetBookings(uid);

            return Ok(bookings);
        }

        [HttpPost("MakeBooking")]
        public async Task<IActionResult> MakeBooking([FromBody] MakeBookingRequestBody RequestBody)
        {

            var fromAddress = "young.jiapeng@outlook.com";
            var toAddress = RequestBody.email;
            var subject = "Booking Confirmed!";

            var body = new StringBuilder()
                .AppendLine("Dear Customer,")
                .AppendLine("")
                .AppendLine("Your booking has been successful")
                .AppendLine("")
                .AppendLine("Kind Regards,")
                .AppendLine("Under the C")
            .ToString();

            _emailService.SendEmail(fromAddress, toAddress, subject, body);

            return Ok();
        }

        [HttpGet("ShowBookingDetails")]
        public async Task<IActionResult> ShowBookingDetails([FromQuery] int bookingId)
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
            var b = await _bookingRepository.GetBookingById(RequestBody.bookingId);

            if (b == null)
            {
                return NotFound();
            }

            try
            {
                await _bookingRepository.RemoveBooking(b);

                return Ok();
            } catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
