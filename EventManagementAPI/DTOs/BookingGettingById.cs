using EventManagementAPI.Models;

namespace EventManagementAPI.DTOs
{
    public class BookingGettingById
    {
        public Booking booking { get; set; }
        public List<Ticket> tickets { get; set; }
    }
}
