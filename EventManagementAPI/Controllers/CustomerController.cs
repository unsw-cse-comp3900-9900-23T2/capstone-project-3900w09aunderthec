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

    public class SubscribeHosterRequestBody
    {
        public int customerId { get; set; }
        public int hosterId { get; set; }
    }

    public class UndoSubscribeHosterRequestBody
    {
        public int subscriptionId { get; set; }
    }

    public class SaveEventRequestBody
    {
        public int customerId { get; set; }
        public int eventId { get; set; }
    }

    public class UndoSaveEventRequestBody
    {
        public int saveEventId { get; set; }
    }

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

        [HttpPost("Subscribe")]
        public async Task<IActionResult> SubscribeHoster([FromBody] SubscribeHosterRequestBody requestBody)
        {
            var customerId = requestBody.customerId;
            var hosterId = requestBody.hosterId;

            var subscibeResult = await _customerRepository.SubscribeHoster(customerId, hosterId);
            return Ok(subscibeResult);
        }

        [HttpPost("UndoSubscribe")]
        public async Task<IActionResult> UndoSubscribeHoster([FromBody] UndoSubscribeHosterRequestBody requestBody)
        {
            var subscriptionId = requestBody.subscriptionId;

            var undoSubscribeResult = await _customerRepository.UndoSubscribeHoster(subscriptionId);
            return Ok(undoSubscribeResult);
        }

        [HttpPost("SaveEvent")]
        public async Task<IActionResult> SaveEvent([FromBody] SaveEventRequestBody requestBody)
        {
            var customerId = requestBody.customerId;
            var eventId = requestBody.eventId;

            var saveEvent = await _customerRepository.SaveEvent(customerId, eventId);
            return Ok(saveEvent);
        }

        [HttpPost("UndoSaveEvent")]
        public async Task<IActionResult> UndoSaveEvent([FromBody] UndoSaveEventRequestBody requestBody)
        {
            var saveEventId = requestBody.saveEventId;

            var undoSubscribeResult = await _customerRepository.UndoSaveEvent(saveEventId);
            return Ok(undoSubscribeResult);
        }
    }
}
