using EventManagementAPI.Models;

namespace EventManagementAPI.DTOs
{
    public class TicketModificationDTO
    {
        public int ticketId { get; set; }
        public String? name { get; set; }
        public Double? price { get; set; }
        public int? stock { get; set; }
    }
}
