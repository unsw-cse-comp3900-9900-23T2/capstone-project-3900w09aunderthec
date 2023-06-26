using EventManagementAPI.Context;
using EventManagementAPI.Models;
using System.Linq;
using EventManagementAPI.Repositories;
using Microsoft.EntityFrameworkCore;

namespace EventManagementAPI.Repositories
{
    public class TicketRepository : ITicketRepository
    {
        private readonly MySqlContext _dbContext;

        public TicketRepository(MySqlContext dbContext)
        {
            _dbContext = dbContext;
        }

        // public Task<List<Ticket>> GetAllBookingTickets(int customerId)
        // {

        // }

        public async Task CreateBookingTicket(Ticket t)
        {
            _dbContext.tickets.Add(t);
            await _dbContext.SaveChangesAsync();
        }

        public async Task<List<Ticket>> ShowEventTickets(int eventId)
        {
            var tickets =await _dbContext.tickets
                .Where(t => t.eventIdRef == eventId)
                .ToListAsync();

            return tickets;
        }
    }
}
