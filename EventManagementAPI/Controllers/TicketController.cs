using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using Microsoft.AspNetCore.Mvc;
using EventManagementAPI.Repositories;

namespace EventManagementAPI.Controllers{

    public class ShowTicketsRequestInfo {};
    public class BookTicketsRequestInfo {};

    [ApiController]
    [Route("[controller]")]
    public class TicketController : ControllerBase
    {

        [HttpPost("ShowTickets")]
        public String ShowTickets([FromBody] ShowTicketsRequestInfo RequestBody) {

            throw new NotImplementedException();
        }

        [HttpPost("BookTickets")]
        public String BookTickets([FromBody] BookTicketsRequestInfo RequestBody) {

            throw new NotImplementedException();
        }

    }
}