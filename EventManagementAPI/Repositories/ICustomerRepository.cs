using System.Collections.Generic;
using System.Threading.Tasks;
using EventManagementAPI.Models;

namespace EventManagementAPI.Repositories
{
    public interface ICustomerRepository
    {
        public Task<List<Customer>> GetAllCustomers();
        public Task<Customer> GetCustomerById(int customerId);
    }
}
