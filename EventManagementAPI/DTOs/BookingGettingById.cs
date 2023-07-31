using EventManagementAPI.Models;

namespace EventManagementAPI.DTOs
{
    public class BookingGettingById
    {
        public Booking booking { get; set; }
        public List<TicketInfoDto> tickets { get; set; }
    }
}
