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

        public async Task CreateBookingTicket(Ticket t)
        {
            _dbContext.tickets.Add(t);
            await _dbContext.SaveChangesAsync();
        }

        public async Task<List<Ticket>> ShowEventTickets(int eventId)
        {
            var tickets = await _dbContext.tickets
                .Where(t => t.eventIdRef == eventId)
                .ToListAsync();

            return tickets;
        }

        public async Task<Ticket> GetTicketById(int ticketId)
        {
            var t = await _dbContext.tickets.FindAsync(ticketId);

            return t;
        }

        public async Task ModifyTicket(TicketModificationDTO mod)
        {
            Ticket t = await _dbContext.tickets.FirstAsync(t => t.ticketId == mod.ticketId);

            if(mod.name is not null){t.name = mod.name;}
            if(mod.price is not null){t.price = mod.price ?? default(Double);}
            if(mod.stock is not null){t.stock = mod.stock ?? default(int);}

            _dbContext.tickets.Update(t);
            await _dbContext.SaveChangesAsync();
        }

        public async Task DeleteTicket(Ticket t)
        {
            _dbContext.tickets.Remove(t);
            await _dbContext.SaveChangesAsync();
        }
    }
}
