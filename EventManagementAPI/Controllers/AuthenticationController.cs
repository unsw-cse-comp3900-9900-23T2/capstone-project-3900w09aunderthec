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
    [Route("authentication")]
    public class AuthenticationController : ControllerBase
    {
        private readonly IAuthenticationRepository _authenticationRepository;

        public AuthenticationController(IAuthenticationRepository authenticationRepository)
        {
            _authenticationRepository = authenticationRepository;
        }

        [HttpPost]
        [Route("Authenticate")]
        public bool AuthenticateUser([FromBody] User user)
        {
            return _authenticationRepository.validateUser(user);
        }

        [HttpPost]
        [Route("Register")]
        public bool RegisterUser()
        {
            return true;
        }
    }
}

