using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using Microsoft.AspNetCore.Mvc;
using EventManagementAPI.DTOs;

namespace EventManagementAPI.Controllers{

    public class CreateTicketsRequestBody
    {
        public double price { get; set; }
        public string name { get; set; }
        public int eventId { get; set; }
        public int stock { get; set; }
        public DateTime availableTime { get; set; }
    };

    public class ModifyTicketsRequestBody
    {
        public int ticketId { get; set; }
        public double? price { get; set; }
        public string? name { get; set; }
        public int? stock { get; set; }
        public DateTime availableTime { get; set; }
    };

    public class DeleteTicketsRequestBody
    {
        public int ticketId { get; set; }
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

        [HttpGet("ShowTickets")]
        public async Task<IActionResult> ShowTickets([FromQuery] int eventId, int customerId) {

            var tickets = await _ticketRepository.ShowEventTickets(eventId, customerId);

            return Ok(tickets);
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
                stock = RequestBody.stock,
                availableTime = RequestBody.availableTime,
            };

            await _ticketRepository.CreateBookingTicket(newTicket);

            return Ok(newTicket.ticketId);
        }

        [HttpGet("ShowTicketDetails")]
        public async Task<IActionResult> ShowTicketDetails([FromQuery] int ticketId)
        {
            var t = await _ticketRepository.GetTicketById(ticketId);

            if (t == null)
            {
                return NotFound();
            }

            return Ok(t);
        }

        [HttpPut("ModifyTickets")]
        public async Task<IActionResult> ModifyTickets([FromBody] ModifyTicketsRequestBody requestBody)
        {
            var t = await _ticketRepository.GetTicketById(requestBody.ticketId);
            if (t == null)
            {
                return NotFound("That ticket does not exist");
            }

           TicketModificationDTO mod = new TicketModificationDTO
            {
                ticketId = requestBody.ticketId,
                name = requestBody.name,
                price = requestBody.price,
                stock = requestBody.stock,
                availableTime = requestBody.availableTime,
            };

            await _ticketRepository.ModifyTicket(mod);
            return Ok(mod);
        }

        [HttpDelete("DeleteTickets")]
        public async Task<IActionResult> DeleteTickets([FromBody] DeleteTicketsRequestBody RequestBody)
        {
            var t = await _ticketRepository.GetTicketById(RequestBody.ticketId);
            if (t == null)
            {
                return NotFound();
            }

            await _ticketRepository.DeleteTicket(t);
            return Ok(t);
        }

        [HttpGet("GetMyTickets")]
        public async Task<IActionResult> GetMyTickets([FromQuery] int eventId, int customerId)
        {
            var l = await _ticketRepository.GetMyTickets(eventId, customerId);

            return Ok(l);
        }
    }
}
