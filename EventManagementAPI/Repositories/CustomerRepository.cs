using EventManagementAPI.Context;
using EventManagementAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace EventManagementAPI.Repositories
{
    public class CustomerRepository
    {
        private readonly MySqlContext _dbContext;

        public CustomerRepository(MySqlContext dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task<List<Customer>> GetAllCustomers()
        {
            return await _dbContext.Customers.ToListAsync();
        }
    }
}
