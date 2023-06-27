using EventManagementAPI.Context;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using Microsoft.EntityFrameworkCore;

namespace EventManagementAPI.Repositories
{
    public class CustomerRepository : ICustomerRepository
    {
        private readonly MySqlContext _dbContext;

        public CustomerRepository(MySqlContext dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task<List<Customer>> GetAllCustomers()
        {
            return await _dbContext.customers.ToListAsync();
        }

        public async Task<Customer> GetCustomerById(int customerId)
        {
            return await _dbContext.customers.FindAsync(customerId);
        }
    }
}
