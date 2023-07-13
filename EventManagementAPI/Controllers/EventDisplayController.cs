using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using Microsoft.AspNetCore.Mvc;

namespace EventManagementAPI.Controllers{

    [ApiController]
    [Route("[controller]")]
    public class EventDisplayController : ControllerBase
    {
        private readonly IEventRepository _eventDisplayRepository;

        public EventDisplayController(IEventRepository eventDisplayRepository)
        {
            _eventDisplayRepository = eventDisplayRepository;
        }

        [HttpGet("ListEvents")]
        public async Task<IActionResult> ListEvents() {

            var events = await _eventDisplayRepository.GetAllEvents();
            return Ok(events);
        }

        [HttpGet("ListHostEvents")]
        public async Task<IActionResult> ListHostEvents([FromQuery] int hostId)
        {

            var events = await _eventDisplayRepository.GetAllHostEvents(hostId);
            return Ok(events);
        }

        [HttpGet("ShowEventDetails")]
        public async Task<IActionResult> ShowEventDetails([FromQuery] int eventId) {

            var e = await _eventDisplayRepository.GetEventById(eventId);
            return Ok(e);
        }

        [HttpGet("ListSimilarEvents")]
        public String ListSimilarEvents([FromQuery] string uid, string eventId) {

            // Not being implemented in sprint 1

            throw new NotImplementedException();
        }

        [HttpGet("ListMyEvents")]
        public String ListMyEvents([FromQuery] string uid) {

            // As I write these descriptions, the more I realise that pretty much all this
            // funcitonality will be handled by database queries
            // Query the database for the given host's events and return them.

            throw new NotImplementedException();
        }

    }
}

