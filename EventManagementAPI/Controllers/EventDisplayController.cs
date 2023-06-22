using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using Microsoft.AspNetCore.Mvc;

namespace EventManagementAPI.Controllers{

    public class ListEventsRequestInfo {};
    public class ShowEventDetailsRequestInfo {};
    public class ListSimilarEventsRequestInfo {};
    public class ListMyEventsRequestInfo {};

    [ApiController]
    [Route("[controller]")]
    public class EventDisplayController : ControllerBase
    {

        [HttpPost("ListEvents")]
        public String ListEvents([FromBody] ListEventsRequestInfo RequestBody) {

            throw new NotImplementedException();
        }

        [HttpPost("ShowEventDetails")]
        public String ShowEventDetails([FromBody] ShowEventDetailsRequestInfo RequestBody) {

            throw new NotImplementedException();
        }

        [HttpPost("ListSimilarEvents")]
        public String ListSimilarEvents([FromBody] ListSimilarEventsRequestInfo RequestBody) {

            throw new NotImplementedException();
        }

        [HttpPost("ListMyEvents")]
        public String ListMyEvents([FromBody] ListMyEventsRequestInfo RequestBody) {

            throw new NotImplementedException();
        }

    }
}

