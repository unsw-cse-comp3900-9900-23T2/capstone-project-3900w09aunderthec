using EventManagementAPI.Context;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using Microsoft.AspNetCore.JsonPatch;
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

        public async Task<Customer?> GetCustomerById(int customerId)
        {
            return await _dbContext.customers.FindAsync(customerId);
        }

        public async Task<Customer> UpdateCustomerByPatch(int id, JsonPatchDocument<Customer> customerDocument)
        {
            var customerById = await _dbContext.customers.FindAsync(id);
            if (customerById == null)
            {
                return customerById;
            }

            customerDocument.ApplyTo(customerById);
            await _dbContext.SaveChangesAsync();

            return customerById;
        }

        public async Task<Customer> UpdateCustomer(Customer customer)
        {
            _dbContext.customers.Update(customer);
            await _dbContext.SaveChangesAsync();

            return customer;
        }
    }
}
