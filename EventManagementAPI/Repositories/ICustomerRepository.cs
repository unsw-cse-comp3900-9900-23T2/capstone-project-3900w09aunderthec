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
    }
}
