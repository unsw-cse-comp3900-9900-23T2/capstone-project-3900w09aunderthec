using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using Microsoft.AspNetCore.Mvc;

namespace EventManagementAPI.Controllers{

    public class GetTagsRequestBody {
        public String title;
        public String description;
        public String venue;
    };
    public class CreateEventRequestBody {
        public int hostUid;
        public String title;
        public DateTime time;
        public String venue;
        public String description;
        public Boolean allowRefunds;
        public Boolean privateEvent;
        public List<String> tags;
        public List<Ticket> tickets;
    };
    public class ModifyEventRequestBody {
        public int eventId; // Id of event being modified
        public int hostUid; // Uid of host to whom the event belongs. Cannot be modified.
        public String title;
        public DateTime time;
        public String venue;
        public String description;
        public Boolean allowRefunds;
        public Boolean privateEvent;
        public List<String> tags;
        public List<Ticket> tickets;
    };

    [ApiController]
    [Route("[controller]")]
    public class EventCreationController : ControllerBase
    {

            // 'Event id counter' needs to be an incremented counter in the database
        private int eventIdCounter = 0;

        [HttpPost("GetTags")]
        public String GetTags([FromBody] GetTagsRequestBody RequestBody) {

            // Format string to make api call with
            // make api call
            // parse recommended tags from api response string
            // return recommended tags

            throw new NotImplementedException();
        }

        [HttpPost("CreateEvent")]
        public String CreateEventDetails([FromBody] CreateEventRequestBody RequestBody) {

            // string authHeader = HttpContext.Request.Headers["Authorization"];
            // Line above should be used to gather authentication key when it is implemented

            eventIdCounter += 1;

            Event newEvent = new Event
            {
                eventId = eventIdCounter,
                title = RequestBody.title,
                time = RequestBody.time,
                venue = RequestBody.venue,
                description = RequestBody.description,
                allowRefunds = RequestBody.allowRefunds,
                privateEvent = RequestBody.privateEvent,
                rating = null,
                comments = new List<Comment>(),
                tags = RequestBody.tags
            };

            // Old code for unpacking condensed ticket information. May still be useful
            // foreach (var ticket in RequestBody.tickets) {
            //     newEvent.tickets.AddRange(Enumerable.Repeat(new Ticket{
            //         name = ticket.Item1,
            //         price = ticket.Item2
            //     }, ticket.Item3));
            // }

            // get host with uid hostUid from DB
            // append event to host's list
            // commit to DB

            throw new NotImplementedException();
        }

        [HttpPost("ModifyEvent")]
        public String ModifyEvent([FromBody] ModifyEventRequestBody RequestBody) {

            Event newEvent = new Event
            {
                eventId = RequestBody.eventId,
                title = RequestBody.title,
                time = RequestBody.time,
                venue = RequestBody.venue,
                description = RequestBody.description,
                allowRefunds = RequestBody.allowRefunds,
                privateEvent = RequestBody.privateEvent,
                rating = null,
                comments = new List<Comment>(),
                tags = RequestBody.tags
            };

            // get event with eventId from DB
            // compare differences and message ticket holders if necessary
            // for example, date change should trigger a message to ticket holders
            // get host with hostUid
            // replace old event with newEvent

            throw new NotImplementedException();
        }

    }
}

