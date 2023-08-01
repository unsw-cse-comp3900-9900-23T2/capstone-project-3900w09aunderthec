using EventManagementAPI.Models;

namespace EventManagementAPI.DTOs
{
    public class TicketSoldDto
    {
        public Ticket ticket { get; set; }
        public DateTime soldTime { get; set; }
    }
}
