using EventManagementAPI.Models;

namespace EventManagementAPI.DTOs
{
    public class BookingResultDTO
    {
        public Booking booking { get; set; }
        public string eventName { get; set; }
    }
}
