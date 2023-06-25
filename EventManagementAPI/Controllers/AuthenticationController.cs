using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using Microsoft.AspNetCore.Mvc;
using EventManagementAPI.Repositories;

namespace EventManagementAPI.Controllers
{
    public class RegisterUserRequestBody {
        public string username {get; set;} = "no username";
        public string email {get; set;}
        public bool isHost {get; set;} = false;
    };

    [ApiController]
    [Route("[controller]")]
    public class AuthenticationController : ControllerBase
    {
        private readonly IAuthenticationRepository _authenticationRepository;

        public AuthenticationController(IAuthenticationRepository authenticationRepository)
        {
            _authenticationRepository = authenticationRepository;
        }

        [HttpPost("RegisterUser")]
        public IActionResult RegisterUser([FromBody] RegisterUserRequestBody RequestBody) {

            if (!_authenticationRepository.validateEmailRegex(RequestBody.email)) {
                return BadRequest("That email is invalid.");
            }

            if (!_authenticationRepository.checkDuplicateEmails(RequestBody.email).Result) {
                return BadRequest("That email is already in use.");
            }

            _authenticationRepository.createUser(RequestBody.username, RequestBody.email, RequestBody.isHost);

            return Ok();
        }

    }
}

