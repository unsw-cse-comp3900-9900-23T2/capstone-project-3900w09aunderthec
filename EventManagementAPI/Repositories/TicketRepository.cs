using EventManagementAPI.Context;
using EventManagementAPI.Models;
using System.Linq;
using EventManagementAPI.Repositories;
using Microsoft.EntityFrameworkCore;
using EventManagementAPI.DTOs;

namespace EventManagementAPI.Repositories
{
    public class TicketRepository : ITicketRepository
    {
        private readonly MySqlContext _dbContext;

        public TicketRepository(MySqlContext dbContext)
        {
            _dbContext = dbContext;
        }

        /// <summary>
        /// Create a ticket
        /// </summary>
        /// <param name="t"></param>
        /// <returns>
        /// void
        /// </returns>
        public async Task CreateBookingTicket(Ticket t)
        {
            _dbContext.tickets.Add(t);
            await _dbContext.SaveChangesAsync();
        }

        /// <summary>
        /// Get a list of tickets for an event
        /// </summary>
        /// <param name="eventId"></param>
        /// <returns>
        /// A list of Ticket objects
        /// </returns>
        public async Task<List<Ticket>> ShowEventTickets(int eventId)
        {
            var tickets = await _dbContext.tickets
                .Where(t => t.eventIdRef == eventId)
                .ToListAsync();

            return tickets;
        }

        /// <summary>
        /// Get details of a ticket
        /// </summary>
        /// <param name="ticketId"></param>
        /// <returns>
        /// A Ticket object with details
        /// </returns>
        /// <exception cref="KeyNotFoundException"></exception>
        public async Task<Ticket> GetTicketById(int ticketId)
        {
            var t = await _dbContext.tickets.FindAsync(ticketId) ?? throw new KeyNotFoundException("ticket not found");

            return t;
        }

        /// <summary>
        /// Update a ticket
        /// </summary>
        /// <param name="mod"></param>
        /// <returns>
        /// A Ticket object that is updated
        /// </returns>
        public async Task<Ticket> ModifyTicket(TicketModificationDTO mod)
        {
            Ticket t = await _dbContext.tickets.FirstAsync(t => t.ticketId == mod.ticketId);

            if(mod.name is not null){t.name = mod.name;}
            if(mod.price is not null){t.price = mod.price ?? default(Double);}
            if(mod.stock is not null){t.stock = mod.stock ?? default(int);}
            if(mod.availableTime is not null){ t.availableTime = mod.availableTime.Value; }

            _dbContext.tickets.Update(t);
            await _dbContext.SaveChangesAsync();
            return t;
        }

        /// <summary>
        /// Delete a ticket
        /// </summary>
        /// <param name="t"></param>
        /// <returns>
        /// void
        /// </returns>
        public async Task DeleteTicket(Ticket t)
        {
            _dbContext.tickets.Remove(t);
            await _dbContext.SaveChangesAsync();
        }

        /// <summary>
        /// Get all booked tickets for an event
        /// </summary>
        /// <param name="eventId"></param>
        /// <param name="customerId"></param>
        /// <returns>
        /// A list of key-value pairs where the key represents the ticket name and value represents the number of tickets booked
        /// </returns>
        /// <exception cref="KeyNotFoundException"></exception>
        public async Task<Dictionary<string,int>> GetMyTickets(int eventId, int customerId) {
            if (!await _dbContext.customers
                .AnyAsync(c => c.uid == customerId)) {
                throw new KeyNotFoundException("That customer does not exist");
            }
            if (!await _dbContext.events
                .AnyAsync(e => e.eventId == eventId)) {
                throw new KeyNotFoundException("That event does not exist");
            }

            var query = await _dbContext.bookingTickets
                .Join(_dbContext.tickets,
                    bt => bt.ticketId,
                    t => t.ticketId,
                    (bt,t) => new
                    {
                        bt.booking.customerId,
                        t.name,
                        bt.numberOfTickets
                    })
                .Where(c => c.customerId == customerId)
                .ToListAsync();

            var response = new Dictionary<string,int>();
            
            foreach(var tuple in query)
            {
                response.Add(tuple.name, tuple.numberOfTickets);
            }

            return response;
        }
    }
}
