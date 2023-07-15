using EventManagementAPI.Context;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System.Globalization;

namespace EventManagementAPI.Repositories
{
    public class EventRepository : IEventRepository
    {
        private readonly MySqlContext _dbContext;

        public EventRepository(MySqlContext dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task<List<Event>> GetAllEvents(int? hostId, string sortby)
        {
            IQueryable<Event> query;
            if (hostId != -1)
            {
                query = _dbContext.events.Where(e => e.hosterFK == hostId && e.privateEvent == false);
            } else
            {
                query = _dbContext.events.Where(e => e.privateEvent == false);
            }

            switch (sortby)
            {
                case "most_recent":
                    query = query.OrderByDescending(e => e.createdTime);
                    break;
                case "most_saved":
                    query = query.OrderByDescending(e => e.numberSaved);
                    break;
                default:
                    break;
            }

            var events = await query.ToListAsync();

            return events;
        }

        public async Task CreateAnEvent(Event e)
        {
            if (!await _dbContext.hosts
                .AnyAsync(h => h.uid == e.hosterFK)) {
                throw new BadHttpRequestException("That host does not exist");
            }
                
            _dbContext.events.Add(e);
            await _dbContext.SaveChangesAsync();
        }

        public async Task<Event> GetEventById(int id)
        {
            var e = await _dbContext.events
                .FirstOrDefaultAsync(e => e.eventId == id);
            return e;
        }

        public async Task ModifyEvent(Event e)
        {
            _dbContext.events.Update(e);
            await _dbContext.SaveChangesAsync();
        }

        public async Task<Event?> CancelEvent(int eventId)
        {
            var e = await _dbContext.events.FindAsync(eventId);

            if (e != null)
            {
                _dbContext.Remove(e);
                await _dbContext.SaveChangesAsync();
            }

            return e;
        }
    }
}
