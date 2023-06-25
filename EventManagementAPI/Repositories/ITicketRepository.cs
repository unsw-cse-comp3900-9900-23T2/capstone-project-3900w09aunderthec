using System.Collections.Generic;
using System.Threading.Tasks;
using EventManagementAPI.Models;

namespace EventManagementAPI.Repositories
{
    public interface ITicketRepository
    {
        public Task<List<Ticket>> GetAllBookingTickets(int customerId);
        public Task CreateBookingTicket();
        public Task<Ticket> ShowEventTickets(int eventId);
    }
}
