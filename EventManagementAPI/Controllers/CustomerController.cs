using Microsoft.AspNetCore.Mvc;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using Microsoft.AspNetCore.JsonPatch;
using Newtonsoft.Json;

namespace EventManagementAPI.Controllers
{
    public class UpdateCustomerRequestBody
    {
        public String email { get; set; }
        public String username { get; set; }
        public int vipLevel { get; set; }
        public int loyaltyPoints { get; set; }
    };

    [ApiController]
    [Route("api/[controller]")]
    public class CustomerController : ControllerBase
    {
        private readonly ICustomerRepository _customerRepository;

        public CustomerController(ICustomerRepository customerRepository)
        {
            _customerRepository = customerRepository;
        }

        [HttpGet]
        public async Task<IActionResult> GetAllCustomers()
        {
            var customers = await _customerRepository.GetAllCustomers();
            return Ok(customers);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetCustomerById(int id)
        {
            var customer = await _customerRepository.GetCustomerById(id);

            if (customer == null)
            {
                return NotFound();
            }

            return Ok(customer);
        }

        [HttpPatch("{id}")]
        public async Task<IActionResult> UpdateCustomerByPatch(int id, [FromBody] JsonPatchDocument<Customer> patchDocument)
        {
            var updatedCustomer = await _customerRepository.UpdateCustomerByPatch(id, patchDocument);

            if (updatedCustomer == null)
            {
                return NotFound();
            }
            return Ok(updatedCustomer);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateCustomer(int id, [FromBody] UpdateCustomerRequestBody requestBody)
        {
            var newCustomer = new Customer();
            newCustomer.uid = id;
            newCustomer.email = requestBody.email;
            newCustomer.username = requestBody.username;
            newCustomer.vipLevel = requestBody.vipLevel;
            newCustomer.loyaltyPoints = requestBody.loyaltyPoints;

            var updatedCustomer = await _customerRepository.UpdateCustomer(newCustomer);
            if (updatedCustomer == null)
            {
                return NotFound();
            }

            return Ok(updatedCustomer);
        }
    }
}
