using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using Microsoft.AspNetCore.Mvc;

namespace EventManagementAPI.Controllers
{
    [ApiController]
    [Route("authentication")]
    public class AuthenticationController : ControllerBase
    {
        public AuthenticationController()
        {

        }

        [HttpPost]
        [Route("Authenticate")]
        public string AuthenticateUser([FromBody] User user)
        {
            return user.Username;
        }

        [HttpPost]
        [Route("Register")]
        public bool RegisterUser()
        {
            return true;
        }
    }
}

