using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using Microsoft.AspNetCore.Mvc;

namespace EventManagementAPI.Controllers{

    public class GetTagsRequestInfo {};
    public class CreateEventRequestInfo {};
    public class ModifyEventRequestInfo {};

    [ApiController]
    [Route("[controller]")]
    public class EventCreationController : ControllerBase
    {

        [HttpPost("GetTags")]
        public String GetTags([FromBody] GetTagsRequestInfo RequestBody) {

            throw new NotImplementedException();
        }

        [HttpPost("CreateEvent")]
        public String CreateEventDetails([FromBody] CreateEventRequestInfo RequestBody) {

            throw new NotImplementedException();
        }

        [HttpPost("ModifyEvent")]
        public String ModifyEvent([FromBody] ModifyEventRequestInfo RequestBody) {

            throw new NotImplementedException();
        }

    }
}

