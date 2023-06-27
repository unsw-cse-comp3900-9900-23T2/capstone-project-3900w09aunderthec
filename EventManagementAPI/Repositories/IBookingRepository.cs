using System.Collections.Generic;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using EventManagementAPI.DTOs;

namespace EventManagementAPI.Repositories
{
    public interface IBookingRepository
    {
        public Task MakeBooking(Booking b);
        public Task<List<BookingResultDto>> GetBookings(int customerId);
        public Task<Booking> GetBookingById(int bookingId);
        public Task RemoveBooking(Booking booking);
    }
}
