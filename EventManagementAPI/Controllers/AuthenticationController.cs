using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using Microsoft.AspNetCore.Mvc;
// using EventManagementAPI.Repositories;

namespace EventManagementAPI.Controllers
{

    public class ResetPasswordRequestInfo {
        public string Email {get; set;}
    };
    public class LoginUserRequestInfo {
        public string Username {get; set;}
        public string Password {get; set;}
    };
    public class RegisterUserRequestInfo {
        public string Username {get; set;}
        public string Password {get; set;}
        public string Email {get; set;}
    };


    [ApiController]
    [Route("[controller]")]
    public class AuthenticationController : ControllerBase
    {
        // private readonly IAuthenticationRepository _authenticationRepository;

        // public AuthenticationController(IAuthenticationRepository authenticationRepository)
        // {
        //     _authenticationRepository = authenticationRepository;
        // }

        // [HttpPost]
        // [Route("Authenticate")]
        // public bool AuthenticateUser([FromBody] User user)
        // {
        //     return _authenticationRepository.validateUser(user);
        // }

        // [HttpPost]
        // [Route("Register")]
        // public bool RegisterUser()
        // {
        //     return true;
        // }

        [HttpPost("ResetPassword")]
        public String ResetPassword([FromBody] ResetPasswordRequestInfo RequestBody) {

            // Send password reset email. How difficult is this?

            return "Awaiting implementation";
        }

        [HttpPost("LoginUser")]
        public String LoginUser([FromBody] LoginUserRequestInfo RequestBody) {

            // Check details
            // Delete old session tokens
            // Return session token

            return "Awaiting implementation";
        }

        [HttpPost("RegisterUser")]
        public String RegisterUser([FromBody] RegisterUserRequestInfo RequestBody) {
            Console.WriteLine(RequestBody.Password); // Deleteme

            // Check Email against Regex
            // Check username uniqueness
            // If either fail, return informative fail string?
            // Hash password, generate UID, generate session token
            // Save user and token to database
            // Return session token

            return "Awaiting implementation";
        }

    }
}

