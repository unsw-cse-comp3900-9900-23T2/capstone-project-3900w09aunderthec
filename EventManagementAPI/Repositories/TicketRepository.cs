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

        public async Task<Dictionary<string,int>> GetMyTickets(int eventId, int customerId) {
            if (!await _dbContext.customers
                .AnyAsync(c => c.uid == customerId)) {
                throw new BadHttpRequestException("That customer does not exist");
            }
            if (!await _dbContext.events
                .AnyAsync(e => e.eventId == eventId)) {
                throw new BadHttpRequestException("That event does not exist");
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
