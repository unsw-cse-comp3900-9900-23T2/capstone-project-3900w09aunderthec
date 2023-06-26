using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using Microsoft.AspNetCore.Mvc;

namespace EventManagementAPI.Controllers{

    public class ShowTicketsRequestBody {
        public int eventId { get; set; }
    };
    public class BookTicketsRequestBody {
        public double price { get; set; }
        public string name { get; set; }
        public int eventId { get; set; }
    };

    public class CreateTicketsRequestBody
    {
        public double price { get; set; }
        public string name { get; set; }
        public int eventId { get; set; }
    };

    [ApiController]
    [Route("[controller]")]
    public class TicketController : ControllerBase
    {
        private readonly ITicketRepository _ticketRepository;
        private readonly IEventRepository _eventRepository;

        public TicketController(ITicketRepository ticketRepository, IEventRepository eventRepository)
        {
            _ticketRepository = ticketRepository;
            _eventRepository = eventRepository;
        }

        [HttpPost("ShowTickets")]
        public async Task<IActionResult> ShowTickets([FromBody] ShowTicketsRequestBody RequestBody) {

            var tickets = await _ticketRepository.ShowEventTickets(RequestBody.eventId);

            return Ok(tickets);
        }

        [HttpPost("BookTickets")]
        public async Task<IActionResult> BookTickets([FromBody] BookTicketsRequestBody RequestBody)
        {
            throw new NotImplementedException();
        }

        [HttpPost("CreateTickets")]
        public async Task<IActionResult> CreateTickets([FromBody] CreateTicketsRequestBody RequestBody) {

            var existingEvent = await _eventRepository.GetEventById(RequestBody.eventId);
            if (existingEvent == null)
            {
                return NotFound("Event not found");
            }

            var newTicket = new Ticket
            {
                name = RequestBody.name,
                price = RequestBody.price,
                eventIdRef = RequestBody.eventId,
                toEvent = existingEvent,
            };

            await _ticketRepository.CreateBookingTicket(newTicket);

            return Ok();
        }

    }
}