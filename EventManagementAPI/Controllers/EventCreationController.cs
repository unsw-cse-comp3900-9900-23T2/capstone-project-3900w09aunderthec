using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using EventManagementAPI.DTOs;
using EventManagementAPI.Repositories;
using Microsoft.AspNetCore.Mvc;
using EventManagementAPI.Services;
using System.Text;
using System.Net.Mail;

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

    public class EmailNotificationRequestBody
    {
        public int eventId { get; set; }
        public string subject { get; set; }
        public string body { get; set; }
    }

    [ApiController]
    [Route("[controller]")]
    public class EventCreationController : ControllerBase
    {
        private readonly IEventRepository _eventRepository;
        private readonly IEventHostRepository _eventHostRepository;
        private readonly EmailService _emailService;

        public EventCreationController(IEventRepository eventRepository, IEventHostRepository eventHostRepository, EmailService emailService)
        {
            _eventRepository = eventRepository;
            _eventHostRepository = eventHostRepository;
            _emailService = emailService;
        }

        [HttpGet("GetTags")]
        public async Task<IActionResult> GetTags([FromQuery] string title, string description, string venue) {
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

            var newEvent = new Event
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
                return NotFound("That event does not exist");
            }

            var mod = new EventModificationDTO
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

            var hosterId = e.hosterFK;
            var hoster = _eventHostRepository.GetHosterById(hosterId);

            return Ok(e);
        }

        [HttpPost("EmailNotification")]
        public IActionResult EmailNotification([FromBody] EmailNotificationRequestBody requestBody)
        {
            var eventId = requestBody.eventId;
            var subject = requestBody.subject;
            var body = requestBody.body;

            var buyers = _eventHostRepository.GetBuyers(eventId);

            var fromAddress = "underthecsharp@outlook.com";
            var emailBody = new StringBuilder()
                .AppendLine("Dear Customer, ")
                .AppendLine("")
                .AppendLine(body)
                .AppendLine("")
                .AppendLine("Kind Regards,")
                .AppendLine("Under the C")
                .ToString();

            foreach (Customer buyer in buyers)
            {
                var toAddress = buyer.email;
                _emailService.SendEmail(fromAddress, toAddress, subject, emailBody);
            }

            return Ok();
        }
    }
}

