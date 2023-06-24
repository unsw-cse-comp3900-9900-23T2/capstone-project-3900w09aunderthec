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

            throw new NotImplementedException();
        }

        [HttpPost("ShowEventDetails")]
        public String ShowEventDetails([FromBody] ShowEventDetailsRequestBody RequestBody) {

            throw new NotImplementedException();
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

