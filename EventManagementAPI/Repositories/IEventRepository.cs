using System.Collections.Generic;
using System.Threading.Tasks;
using EventManagementAPI.Models;

namespace EventManagementAPI.Repositories
{
    public interface IEventRepository
    {
        Task<List<string>> GetTags(string descriptorString);
        Task<List<Event>> GetAllEvents(int? hostId, string? sortby, string? tags);
        Task CreateAnEvent(Event e);
        Task<Event> GetEventById(int id);
        Task ModifyEvent(Event e);
        Task<Event?> CancelEvent(int eventId);
    }
}
