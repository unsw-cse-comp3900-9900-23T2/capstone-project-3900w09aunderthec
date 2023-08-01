using Microsoft.AspNetCore.Mvc;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using Microsoft.AspNetCore.JsonPatch;
using Newtonsoft.Json;

namespace EventManagementAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class HosterController : ControllerBase
    {
        private readonly IEventHostRepository _eventHostRepository;

        public HosterController(IEventHostRepository eventHostRepository)
        {
            _eventHostRepository = eventHostRepository;
        }

        [HttpGet("GetSubscribers")]
        public async Task<IActionResult> GetSubscribers([FromQuery] int hosterId, DateTime? time)
        {
            if (!time.HasValue)
            {
                time = DateTime.Now;
            }
            var subscribers = await _eventHostRepository.GetSubscribers(hosterId, time.Value);

            return Ok(subscribers);
        }

        [HttpGet("GetTicketsSold")]
        public async Task<IActionResult> GetTicketsSold([FromQuery] int hosterId, DateTime? time)
        {
            if (!time.HasValue)
            {
                time = DateTime.Now;
            }

            var ticketsSold = await _eventHostRepository.GetTicketsSold(hosterId, time.Value);

            return Ok(ticketsSold);
        }

        [HttpGet("GetPercentageBeaten")]
        public async Task<IActionResult> GetPercentageBeaten([FromQuery] int hosterId, string? rankBy)
        {
            rankBy ??= "subscribers";

            var percentage = await _eventHostRepository.GetPercentageBeaten(hosterId, rankBy);

            return Ok(percentage);
        }

        [HttpGet("GetEventsYearlyDistribution")]
        public async Task<IActionResult> GetEventsYearlyDistribution([FromQuery] int hosterId)
        {
            var events = await _eventHostRepository.GetEventsYearlyDistribution(hosterId);

            return Ok(events);
        }
    }
}

