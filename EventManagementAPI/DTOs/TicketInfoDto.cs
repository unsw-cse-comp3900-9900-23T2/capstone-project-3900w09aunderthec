using EventManagementAPI.Models;

namespace EventManagementAPI.DTOs
{
    public class TicketInfoDto
    {
        public Ticket ticket { get; set; }
        public int numberOfTickets { get; set; }
    }
}