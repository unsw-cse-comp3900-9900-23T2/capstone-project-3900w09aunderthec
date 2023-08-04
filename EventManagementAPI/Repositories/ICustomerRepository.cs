using System.Collections.Generic;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using Microsoft.AspNetCore.JsonPatch;

namespace EventManagementAPI.Repositories
{
    public interface ICustomerRepository
    {
        public Task<List<Customer>> GetAllCustomers();
        public Task<User?> GetCustomerById(int customerId);
        public Task<Customer> UpdateCustomerByPatch(int id, JsonPatchDocument<Customer> customer);
        public Task<Customer> UpdateCustomer(Customer customer);
        public Task<Subscription> SubscribeHoster(int customerId, int hosterId);
        public Task<EventSaved> SaveEvent(int customerId, int eventId);
        public Task<double> RateEvent(int eventId, int rating);
        public Task<bool> isSaved(int customerId, int eventId);
    }
}
