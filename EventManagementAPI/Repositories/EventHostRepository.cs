using EventManagementAPI.Context;
using EventManagementAPI.DTOs;
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

        /// <summary>
        /// Get a list of tickets sold for a hoster for analysis
        /// </summary>
        /// <param name="hosterId"></param>
        /// <param name="time"></param>
        /// <returns>
        /// A list of TicketSoldDto which contains ticket information and sold time
        /// </returns>
        public async Task<List<TicketSoldDto>> GetTicketsSold(int hosterId, DateTime time)
        {
            var query = from booking in _dbContext.Bookings
                          join bookingTicket in _dbContext.BookingTickets
                            on booking.Id equals bookingTicket.Id
                          join ticket in _dbContext.Tickets
                            on bookingTicket.ticketId equals ticket.ticketId
                          join ev in _dbContext.Events
                            on ticket.eventIdRef equals ev.eventId
                          where ev.hosterFK == hosterId && bookingTicket.createdTime <= time
                          select new TicketSoldDto
                          {
                              ticket = ticket,
                              soldTime = bookingTicket.createdTime,
                          };

            var tickets = await query.ToListAsync();

            return tickets;
        }


        /// <summary>
        /// Get how many hosters beaten in percentage by certain criteria
        /// </summary>
        /// <param name="hosterId"></param>
        /// <param name="rankBy"></param>
        /// <returns>
        /// A double value represents the percentage of hosters beaten
        /// </returns>
        public async Task<double> GetPercentageBeaten(int hosterId, string rankBy)
        {
            var totalHosters = _dbContext.Hosts.Count();
            var totalHostersBeaten = 0.0;

            switch (rankBy)
            {
                case "subscribers":
                    var subscriptionsGrouped = await _dbContext.Hosts
                        .GroupJoin(
                            _dbContext.Subscriptions,
                            hoster => hoster.uid,
                            subscription => subscription.hosterIdRef,
                            (hoster, subscriptions) => new
                            {
                                HosterRef = hoster.uid,
                                SubscriptionCount = subscriptions.Count()
                            })
                        .ToListAsync();

                    var specificHosterSubscriptionCount = subscriptionsGrouped
                        .FirstOrDefault(group => group.HosterRef == hosterId)
                        ?.SubscriptionCount ?? 0;

                    totalHostersBeaten = subscriptionsGrouped
                        .Count(group => group.SubscriptionCount < specificHosterSubscriptionCount);
                    break;
                case "events":
                    var eventsGrouped = await _dbContext.Hosts
                        .GroupJoin(
                            _dbContext.Events,
                            hoster => hoster.uid,
                            e => e.hosterFK,
                            (hoster, e) => new
                            {
                                HosterRef = hoster.uid,
                                EventsCount = e.Count()
                            })
                        .ToListAsync();

                    var specificHosterEventCount = eventsGrouped
                        .FirstOrDefault(group => group.HosterRef == hosterId)
                        ?.EventsCount ?? 0;

                    totalHostersBeaten = eventsGrouped
                        .Count(group => group.EventsCount < specificHosterEventCount);
                    break;
                default:
                    break;
            }

            var percentageBeaten = totalHostersBeaten / totalHosters;

            return percentageBeaten;
        }
    }
}
