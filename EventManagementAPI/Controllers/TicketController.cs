using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using Microsoft.AspNetCore.Mvc;

namespace EventManagementAPI.Controllers{

    public class ShowTicketsRequestBody {};
    public class BookTicketsRequestBody {};

    [ApiController]
    [Route("[controller]")]
    public class TicketController : ControllerBase
    {

        [HttpPost("ShowTickets")]
        public String ShowTickets([FromBody] ShowTicketsRequestBody RequestBody) {

            throw new NotImplementedException();
        }

        [HttpPost("BookTickets")]
        public String BookTickets([FromBody] BookTicketsRequestBody RequestBody) {

            throw new NotImplementedException();
        }

    }
}