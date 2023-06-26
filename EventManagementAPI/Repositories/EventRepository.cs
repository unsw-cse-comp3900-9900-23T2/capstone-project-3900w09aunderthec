using EventManagementAPI.Context;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using Microsoft.EntityFrameworkCore;

namespace EventManagementAPI.Repositories
{
    public class EventRepository : IEventRepository
    {
        private readonly MySqlContext _dbContext;

        public EventRepository(MySqlContext dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task<List<Event>> GetAllEvents()
        {
            return await _dbContext.events.ToListAsync();
        }

        public async Task CreateAnEvent(Event e)
        {
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
    }
}
