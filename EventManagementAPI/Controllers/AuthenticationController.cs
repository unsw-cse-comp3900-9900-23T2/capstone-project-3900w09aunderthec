using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using Microsoft.AspNetCore.Mvc;
using EventManagementAPI.Repositories;

namespace EventManagementAPI.Controllers
{

    public class ResetPasswordRequestBody {
        public string email {get; set;}
    };
    // public class LoginUserRequestBody {
    //     public string Username {get; set;}
    //     public string Password {get; set;}
    // };
    public class RegisterUserRequestBody {
        public string username {get; set;}= "no username";
        public string email {get; set;}
        // public bool isHost = false;
    };

    [ApiController]
    [Route("[controller]")]
    public class AuthenticationController : ControllerBase
    {
        private readonly AuthenticationRepository _authenticationRepository;

        public AuthenticationController(AuthenticationRepository authenticationRepository)
        {
            _authenticationRepository = authenticationRepository;
        }

        [HttpPost("ResetPassword")]
        public String ResetPassword([FromBody] ResetPasswordRequestBody RequestBody) {

            // Send password reset email. How difficult is this?

            return "Awaiting implementation";
        }

        // [HttpPost("LoginUser")]
        // public String LoginUser([FromBody] LoginUserRequestBody RequestBody) {

        //     // Check details
        //     // Delete old session tokens
        //     // Return session token

        //     return "Awaiting implementation";
        // }

        [HttpPost("RegisterUser")]
        public IActionResult RegisterUser([FromBody] RegisterUserRequestBody RequestBody) {
            Console.WriteLine(RequestBody.username); // Deleteme

            if (!_authenticationRepository.validateEmailRegex(RequestBody.email)) {
                return BadRequest("That email is invalid.");
            }

            if (!_authenticationRepository.checkDuplicateEmails(RequestBody.email).Result) {
                return BadRequest("That email is invalid.");
            }

            _authenticationRepository.createUser(RequestBody.username, RequestBody.email, false); //RequestBody.isHost);
            // Check Email against Regex
            // Check username uniqueness
            // If either fail, return informative fail string?
            // Hash password, generate UID, generate session token
            // Save user and token to database
            // Return session token

            return Ok();
        }

    }
}

