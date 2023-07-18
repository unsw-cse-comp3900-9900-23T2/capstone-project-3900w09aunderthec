using EventManagementAPI.Models;

namespace EventManagementAPI.DTOs
{
    public class BookingCancellationDTO
    {
        public Booking booking { get; set; }
        public double refundableAmount { get; set; }
        public double refundAsCreditMoney { get; set; }
    }
}
