using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using EventManagementAPI.DTOs;
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
        public async Task<IActionResult> ListEvents([FromQuery] int? uid, string? sortby, string? tags, bool showPreviousEvents, int? eventId)
        {
            var events = await _eventDisplayRepository.GetAllEvents(uid, sortby, tags, showPreviousEvents, eventId);
            return Ok(events);
        }

        [HttpGet("ShowEventDetails")]
        public async Task<IActionResult> ShowEventDetails([FromQuery] int eventId) {

            var e = await _eventDisplayRepository.GetEventById(eventId);
            return Ok(e);
        }
    }
}

