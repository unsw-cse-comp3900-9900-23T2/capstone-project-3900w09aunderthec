using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using EventManagementAPI.DTOs;
using EventManagementAPI.Repositories;
using Microsoft.AspNetCore.Mvc;

namespace EventManagementAPI.Controllers{

    public class GetTagsRequestBody {
        public String title { get; set; }
        public String description { get; set; }
        public String venue { get; set; }
    };
    public class CreateEventRequestBody {
        public int uid { get; set; }
        public string title { get; set; }
        public string venue { get; set; }
        public DateTime eventTime { get; set; }
        public string description { get; set; }
        public bool isDirectRefunds { get; set; }
        public bool isPrivateEvent { get; set; }
        public String tags { get; set; }
        // public List<Ticket> tickets;
    };
    public class ModifyEventRequestBody {
        public int eventId { get; set; }
        public string? title { get; set; }
        public DateTime? eventTime { get; set; }
        public DateTime? createdTime { get; set; }
        public string? venue { get; set; }
        public string? description { get; set; }
        public bool? isDirectRefunds { get; set; }
        public bool? isPrivateEvent { get; set; }
        public String? tags { get; set; }
    };

    public class CancelEventRequestBody
    {
        public int eventId { get; set; }
    }

    [ApiController]
    [Route("[controller]")]
    public class EventCreationController : ControllerBase
    {

        private readonly IEventRepository _eventRepository;

        public EventCreationController(IEventRepository eventRepository)
        {
            _eventRepository = eventRepository;
        }

        [HttpGet("GetTags")]
        public async Task<IActionResult> GetTags([FromQuery] string title, string description, string venue) {

            // Format string to make api call with
            // make api call
            // parse recommended tags from api response string
            // return recommended tags

            string descriptorString = "Title: " + title + "\nDescription: " +
                                      description + "\nVenue: " + venue;

            List<string> tagList = new List<string>();

            try
            {
                tagList = await _eventRepository.GetTags(descriptorString);
            }
            catch (BadHttpRequestException e)
            {
                return BadRequest(e.Message);
            }

            return Ok(tagList);
        }

        [HttpPost("CreateEvent")]
        public async Task<IActionResult> CreateEventDetails([FromBody] CreateEventRequestBody RequestBody)
        {

            // string authHeader = HttpContext.Request.Headers["Authorization"];
            // Line above should be used to gather authentication key when it is implemented

            Event newEvent = new Event
            {
                hosterFK = RequestBody.uid,
                title = RequestBody.title,
                eventTime = RequestBody.eventTime,
                venue = RequestBody.venue,
                description = RequestBody.description,
                isDirectRefunds = RequestBody.isDirectRefunds,
                isPrivateEvent = RequestBody.isPrivateEvent,
                rating = null,
                tags = RequestBody.tags
            };

            try
            {
                await _eventRepository.CreateAnEvent(newEvent);
            }
            catch (BadHttpRequestException e)
            {
                return BadRequest(e.Message);
            }

            return Ok(newEvent);
        }

        [HttpPut("ModifyEvent")]
        public async Task<IActionResult> ModifyEvent([FromBody] ModifyEventRequestBody RequestBody)
        {
            var e = await _eventRepository.GetEventById(RequestBody.eventId);
            if (e == null)
            {
                return NotFound("EventId does not refer to a valid event");
            }

            EventModificationDto mod = new EventModificationDto
            {
                eventId = RequestBody.eventId,
                title = RequestBody.title,
                eventTime = RequestBody.eventTime,
                createdTime = RequestBody.createdTime,
                venue = RequestBody.venue,
                description = RequestBody.description,
                isDirectRefunds = RequestBody.isDirectRefunds,
                isPrivateEvent = RequestBody.isPrivateEvent,
                tags = RequestBody.tags
            };


            // get event with eventId from DB
            // compare differences and message ticket holders if necessary
            // for example, date change should trigger a message to ticket holders
            // get host with hostUid
            // replace old event with newEvent

            await _eventRepository.ModifyEvent(mod);
            return Ok(mod);
        }

        [HttpDelete("CancelEvent")]
        public async Task<IActionResult> CancelEvent([FromBody] CancelEventRequestBody requestBody)
        {
            var e = await _eventRepository.CancelEvent(requestBody.eventId);

            if (e == null)
            {
                return NotFound();
            }

            return Ok(e);
        }
    }
}

