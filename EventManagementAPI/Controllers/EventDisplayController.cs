using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using Microsoft.AspNetCore.Mvc;

namespace EventManagementAPI.Controllers{

    public class ListEventsRequestBody {
        public string uid { get; set; }
    };
    public class ShowEventDetailsRequestBody {
        public int eventId { get; set; }
    };
    public class ListSimilarEventsRequestBody {
        public string uid { get; set; }
        public string eventId { get; set; }
    };
    public class ListMyEventsRequestBody {
        public string uid { get; set; }
    };

    [ApiController]
    [Route("[controller]")]
    public class EventDisplayController : ControllerBase
    {
        private readonly IEventRepository _eventDisplayRepository;

        public EventDisplayController(IEventRepository eventDisplayRepository)
        {
            _eventDisplayRepository = eventDisplayRepository;
        }

        [HttpPost("ListEvents")]
        public async Task<IActionResult> ListEvents([FromBody] ListEventsRequestBody RequestBody) {

            var events = await _eventDisplayRepository.GetAllEvents();
            return Ok(events);
        }

        [HttpPost("ShowEventDetails")]
        public async Task<IActionResult> ShowEventDetails([FromBody] ShowEventDetailsRequestBody RequestBody) {

            var eventId = RequestBody.eventId;
            var e = await _eventDisplayRepository.GetEventById(eventId);
            return Ok(e);
        }

        [HttpPost("ListSimilarEvents")]
        public String ListSimilarEvents([FromBody] ListSimilarEventsRequestBody RequestBody) {

            throw new NotImplementedException();
        }

        [HttpPost("ListMyEvents")]
        public String ListMyEvents([FromBody] ListMyEventsRequestBody RequestBody) {

            throw new NotImplementedException();
        }

    }
}

