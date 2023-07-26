using EventManagementAPI.Models;

namespace EventManagementAPI.DTOs
{
    public class BookingCreationDto
    {
        public required Booking Booking { get; set; }
        public required double DiscountGet { get; set; }
        public required int NewLoyaltyPoints { get; set; }
        public required int NewAvailableLoyaltyPoints { get; set; }
        public required int NewVipLevel { get; set; }
    }
}
