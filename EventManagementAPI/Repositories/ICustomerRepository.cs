using System.Collections.Generic;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using Microsoft.AspNetCore.JsonPatch;

namespace EventManagementAPI.Repositories
{
    public interface ICustomerRepository
    {
        public Task<List<Customer>> GetAllCustomers();
        public Task<Customer> GetCustomerById(int customerId);
        public Task<Customer> UpdateCustomerByPatch(int id, JsonPatchDocument<Customer> customer);
        public Task<Customer> UpdateCustomer(Customer customer);
        public Task<bool> SubscribeHoster(int customerId, int hosterId);
        public Task<bool> UndoSubscribeHoster(int subscriptionId);
        public Task<bool> SaveEvent(int customerId, int eventId);
        public Task<bool> UndoSaveEvent(int saveEventId);
    }
}
