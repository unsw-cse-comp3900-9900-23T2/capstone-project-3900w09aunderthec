using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using Microsoft.AspNetCore.Mvc;
using EventManagementAPI.Repositories;

namespace EventManagementAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class AuthenticationController : ControllerBase
    {
        private readonly IAuthenticationRepository _authenticationRepository;

        public AuthenticationController(IAuthenticationRepository authenticationRepository)
        {
            _authenticationRepository = authenticationRepository;
        }

        [HttpGet("RegisterUser")]
        public IActionResult RegisterUser([FromQuery] string username, string email, bool isHost) {

            if (!_authenticationRepository.validateEmailRegex(email)) {
                return BadRequest("That email is invalid.");
            }

            if (!_authenticationRepository.checkDuplicateEmails(email).Result) {
                return BadRequest("That email is already in use.");
            }

            _authenticationRepository.createUser(username, email, isHost);

            return Ok();
        }

        [HttpGet("GetInitialData")]
        public async Task<IActionResult> GetInitialData([FromQuery] string email)
        {
            if (!_authenticationRepository.validateEmailRegex(email))
            {
                return BadRequest("That email is invalid.");
            }

            InitialData userData = await _authenticationRepository.getInitialData(email);

            return Ok(userData);
        }

    }
}

