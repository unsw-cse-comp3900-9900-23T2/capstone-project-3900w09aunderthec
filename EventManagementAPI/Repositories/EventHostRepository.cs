using EventManagementAPI.Context;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using Microsoft.EntityFrameworkCore;
using System.Globalization;

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
            return await _dbContext.Hosts.ToListAsync();
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
            return await _dbContext.Hosts.FindAsync(hosterId);
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
            var buyers = _dbContext.BookingTickets
                .Join(_dbContext.Tickets,
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

        /// <summary>
        /// Get all hoster subscribers
        /// </summary>
        /// <param name="hosterId"></param>
        /// <returns>
        /// A list of customer objects who subscribed the hoster
        /// </returns>
        public async Task<List<Customer>> GetSubscribers(int hosterId, DateTime time)
        {
            var subscribers =await _dbContext.Subscriptions
                .Join(_dbContext.Customers,
                    s => s.customerIdRef,
                    c => c.uid,
                    (s, c) => new
                    {
                        s,
                        c,
                    })
                .Where(sub => sub.s.hosterIdRef == hosterId && sub.s.subscriptionTime <= time)
                .Select(sub => sub.c)
                .Distinct()
                .ToListAsync();

            return subscribers;
        }
    }
}
