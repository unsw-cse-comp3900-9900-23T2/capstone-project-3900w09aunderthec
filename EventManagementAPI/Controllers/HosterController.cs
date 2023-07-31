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
        public async Task<IActionResult> GetSubscribers([FromQuery] int hosterId)
        {
            var subscribers = await _eventHostRepository.GetSubscribers(hosterId);

            return Ok(subscribers);
        }
    }
}
