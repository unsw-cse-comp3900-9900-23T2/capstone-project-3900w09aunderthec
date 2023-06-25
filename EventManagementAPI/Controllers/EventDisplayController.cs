using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using Microsoft.AspNetCore.Mvc;

namespace EventManagementAPI.Controllers{

    public class ListEventsRequestBody {
        public string uid;
    };
    public class ShowEventDetailsRequestBody {
        public string eventId;
    };
    public class ListSimilarEventsRequestBody {
        public string uid;
        public string eventId;
    };
    public class ListMyEventsRequestBody {
        public string uid;
    };

    [ApiController]
    [Route("[controller]")]
    public class EventDisplayController : ControllerBase
    {

        [HttpPost("ListEvents")]
        public String ListEvents([FromBody] ListEventsRequestBody RequestBody) {

            // Just access the db and return a list of all events for now.
            // In a future sprint, this will run a recommendation algorithm to return the best events

            throw new NotImplementedException();
        }

        [HttpPost("ShowEventDetails")]
        public String ShowEventDetails([FromBody] ShowEventDetailsRequestBody RequestBody) {

            // Query the database for the given event and send return the full event details.
            // Probably will have to be Jsonified

            throw new NotImplementedException();
        }

        [HttpPost("ListSimilarEvents")]
        public String ListSimilarEvents([FromBody] ListSimilarEventsRequestBody RequestBody) {

            // Not being implemented in sprint 1

            throw new NotImplementedException();
        }

        [HttpPost("ListMyEvents")]
        public String ListMyEvents([FromBody] ListMyEventsRequestBody RequestBody) {

            // As I write these descriptions, the more I realise that pretty much all this
            // funcitonality will be handled by database queries
            // Query the database for the given host's events and return them.

            throw new NotImplementedException();
        }

    }
}

