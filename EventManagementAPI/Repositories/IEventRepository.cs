using System.Collections.Generic;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using EventManagementAPI.DTOs;

namespace EventManagementAPI.Repositories
{
    public interface IEventRepository
    {
        Task<List<string>> GetTags(string descriptorString);
        Task<List<EventListingDTO>> GetAllEvents(int? uid, string? sortby, string? tags, bool showPreviousEvents, int? eventId);
        Task CreateAnEvent(Event e);
        Task<Event> GetEventById(int id);
        Task<Event> ModifyEvent(EventModificationDTO mod);
        Task<Event> CancelEvent(int eventId);
    }
}
