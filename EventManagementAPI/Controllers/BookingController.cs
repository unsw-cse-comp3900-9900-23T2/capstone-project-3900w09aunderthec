using Microsoft.AspNetCore.Mvc;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using EventManagementAPI.DTOs;
using System.Net;

namespace EventManagementAPI.Controllers
{
    public class MakeBookingRequestBody
    {
        public int uid { get; set; }
        public int ticketId { get; set; }
        public int ticketNumber { get; set; }
        public DateTime TimeCreated { get; set; }
    }

    public class GetBookingRequestBody
    {
        public int uid { get; set; }
    }

    [ApiController]
    [Route("api/[controller]")]
    public class BookingController : ControllerBase
    {
        private readonly IBookingRepository _bookingRepository;
        private readonly ITicketRepository _ticketRepository;
        private readonly ICustomerRepository _customerRepository;

        public BookingController(IBookingRepository bookingRepository, ITicketRepository ticketRepository, ICustomerRepository customerRepository)
        {
            _bookingRepository = bookingRepository;
            _ticketRepository = ticketRepository;
            _customerRepository = customerRepository;
        }

        [HttpPost("GetBooking")]
        public async Task<IActionResult> GetCustomerBookings(GetBookingRequestBody requestBody)
        {
            var bookings = await _bookingRepository.GetBookings(requestBody.uid);

            return Ok(bookings);
        }

        [HttpPost("MakeBooking")]
        public async Task<IActionResult> MakeBooking(MakeBookingRequestBody RequestBody)
        {
            var customer = await _customerRepository.GetCustomerById(RequestBody.uid);
            var t = await _ticketRepository.GetTicketById(RequestBody.ticketId);

            var newBooking = new Booking
            {
                CustomerId = RequestBody.uid,
                toCustomer = customer,
                TicketId = RequestBody.ticketId,
                toTicket = t,
                TimeCreated = RequestBody.TimeCreated,
            };

            await _bookingRepository.MakeBooking(newBooking);
            return Ok(newBooking);
        }
    }
}
