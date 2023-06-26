using System.Collections.Generic;
using System.Threading.Tasks;
using EventManagementAPI.Models;

namespace EventManagementAPI.Repositories
{
    public interface ITicketRepository
    {
        public Task CreateBookingTicket(Ticket t);
        public Task<List<Ticket>> ShowEventTickets(int eventId);
        public Task<Ticket> GetTicketById(int ticketId);
    }
}
