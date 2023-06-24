using System.Collections.Generic;
using System.Threading.Tasks;
using EventManagementAPI.Models;

namespace EventManagementAPI.Repositories
{
    public interface IEventHostRepository
    {
        Task<List<EventHost>> GetAllEventHosts();
    }
}
