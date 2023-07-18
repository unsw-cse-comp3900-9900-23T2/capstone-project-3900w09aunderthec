using System.Collections.Generic;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using EventManagementAPI.DTOs;

namespace EventManagementAPI.Repositories
{
    public interface ITicketRepository
    {
        public Task CreateBookingTicket(Ticket t);
        public Task<List<Ticket>> ShowEventTickets(int eventId);
        public Task<Ticket> GetTicketById(int ticketId);
        public Task ModifyTicket(TicketModificationDTO mod);
        public Task DeleteTicket(Ticket t);
    }
}
