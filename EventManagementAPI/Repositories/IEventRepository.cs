using System.Collections.Generic;
using System.Threading.Tasks;
using EventManagementAPI.Models;

namespace EventManagementAPI.Repositories
{
    public interface IEventRepository
    {
        Task<List<Event>> GetAllEvents();
        Task CreateAnEvent(Event e);
        Task<Event> GetEventById(int id);
    }
}
