using EventManagementAPI.Models;

namespace EventManagementAPI.DTOs
{
    public class BookingCreationDto
    {
        public required Booking booking { get; set; }
        public required double creditMoneyUsed { get; set; }
        public required double totalPrice { get; set; }
        public required double discountPercentage { get; set; }
        public required double discountGet { get; set; }
        public required int newLoyaltyPoints { get; set; }
        public required int newVipLevel { get; set; }
    }
}
