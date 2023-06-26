using System.Collections.Generic;
using System.Threading.Tasks;
using EventManagementAPI.Models;

namespace EventManagementAPI.Repositories
{
    public interface ITicketRepository
    {
        // public async Task<List<Ticket>> GetAllBookingTickets(int customerId);
        public Task CreateBookingTicket(Ticket t);
        public Task<List<Ticket>> ShowEventTickets(int eventId);
    }
}
