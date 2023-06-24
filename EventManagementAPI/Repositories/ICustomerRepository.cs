using System.Collections.Generic;
using System.Threading.Tasks;
using EventManagementAPI.Models;

namespace EventManagementAPI.Repositories
{
    public interface ICustomerRepository
    {
        Task<List<Customer>> GetAllCustomers();
    }
}
