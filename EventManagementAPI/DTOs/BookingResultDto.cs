using EventManagementAPI.Models;

namespace EventManagementAPI.DTOs
{
    public class BookingResultDto
    {
        public Booking booking { get; set; }
        public string eventName { get; set; }
    }
}
