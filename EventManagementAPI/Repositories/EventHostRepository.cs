using EventManagementAPI.Context;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using Microsoft.EntityFrameworkCore;

namespace EventManagementAPI.Repositories
{
    public class EventHostRepository : IEventHostRepository
    {
        private readonly MySqlContext _dbContext;

        public EventHostRepository(MySqlContext dbContext)
        {
            _dbContext = dbContext;
        }

        /// <summary>
        /// Get all event hosters
        /// </summary>
        /// <returns>
        /// A list of Hoster objects
        /// </returns>
        public async Task<List<Hoster>> GetAllEventHosts()
        {
            return await _dbContext.hosts.ToListAsync();
        }

        /// <summary>
        /// Get hoster by given id
        /// </summary>
        /// <param name="hosterId"></param>
        /// <returns>
        /// A Hoster object
        /// </returns>
        public async Task<Hoster?> GetHosterById(int hosterId)
        {
            return await _dbContext.hosts.FindAsync(hosterId);
        }

        /// <summary>
        /// Get all distinct customers who bought tickets for this event
        /// </summary>
        /// <param name="eventId"></param>
        /// <returns>
        /// A list of Customer objects
        /// </returns>
        public List<Customer> GetBuyers(int eventId)
        {
            var buyers = _dbContext.bookingTickets
                .Join(_dbContext.tickets,
                    bt => bt.ticketId,
                    t => t.ticketId,
                    (bt, t) => new
                    {
                        bt.booking,
                        t.toEvent
                    })
                .Where(e => e.toEvent.eventId == eventId)
                .Select(e => e.booking.toCustomer)
                .Distinct()
                .ToList();

            return buyers;
        }
    }
}
