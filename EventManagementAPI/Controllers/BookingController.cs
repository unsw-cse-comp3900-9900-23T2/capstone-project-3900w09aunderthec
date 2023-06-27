﻿using Microsoft.AspNetCore.Mvc;
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
    };

    public class GetBookingRequestBody
    {
        public int uid { get; set; }
    };

    public class ShowBookingDetailsRequestBody
    {
        public int bookingId { get; set; }
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

        public BookingController(IBookingRepository bookingRepository, ITicketRepository ticketRepository, ICustomerRepository customerRepository)
        {
            _bookingRepository = bookingRepository;
            _ticketRepository = ticketRepository;
            _customerRepository = customerRepository;
        }

        [HttpPost("GetBookings")]
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
                NumberOfTickets = RequestBody.ticketNumber,
                TimeCreated = RequestBody.TimeCreated,
            };

            await _bookingRepository.MakeBooking(newBooking);
            return Ok(newBooking);
        }

        [HttpPost("ShowBookingDetails")]
        public async Task<IActionResult> ShowBookingDetails([FromBody] ShowBookingDetailsRequestBody RequestBody)
        {
            var b = await _bookingRepository.GetBookingById(RequestBody.bookingId);

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