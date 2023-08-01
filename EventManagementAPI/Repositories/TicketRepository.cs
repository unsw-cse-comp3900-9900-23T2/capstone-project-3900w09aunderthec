﻿using EventManagementAPI.Context;
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
            var e = await _dbContext.Events.FirstOrDefaultAsync(e => e.eventId == t.eventIdRef) ?? throw new KeyNotFoundException("event not found");
            t.toEvent = e;
            _dbContext.Tickets.Add(t);
            await _dbContext.SaveChangesAsync();
        }

        /// <summary>
        /// Get a list of tickets for an event
        /// </summary>
        /// <param name="eventId"></param>
        /// <returns>
        /// A list of Ticket objects
        /// </returns>
        public async Task<List<Ticket>> ShowEventTickets(int eventId, int customerId)
        {
            var customer = await _dbContext.Customers.FindAsync(customerId) ?? throw new KeyNotFoundException("customer not found");
            var vipQueueDays = Math.Min(customer.vipLevel / 50, 5);

            var tickets = await _dbContext.Tickets
                .Where(t => t.eventIdRef == eventId && t.availableTime.AddDays(-vipQueueDays) <= DateTime.Now)
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
            var t = await _dbContext.Tickets.FindAsync(ticketId) ?? throw new KeyNotFoundException("ticket not found");

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
            Ticket t = await _dbContext.Tickets.FirstAsync(t => t.ticketId == mod.ticketId);

            if(mod.name is not null){t.name = mod.name;}
            if(mod.price is not null){t.price = mod.price ?? default(Double);}
            if(mod.stock is not null){t.stock = mod.stock ?? default(int);}
            if(mod.availableTime is not null){ t.availableTime = mod.availableTime.Value; }

            _dbContext.Tickets.Update(t);
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
            _dbContext.Tickets.Remove(t);
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
            if (!await _dbContext.Customers
                .AnyAsync(c => c.uid == customerId)) {
                throw new KeyNotFoundException("That customer does not exist");
            }
            if (!await _dbContext.Events
                .AnyAsync(e => e.eventId == eventId)) {
                throw new KeyNotFoundException("That event does not exist");
            }

            var query = await _dbContext.BookingTickets
                .Join(_dbContext.Tickets,
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
