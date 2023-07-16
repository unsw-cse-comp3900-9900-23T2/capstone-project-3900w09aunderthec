using System.Collections.Generic;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using EventManagementAPI.DTOs;

namespace EventManagementAPI.Repositories
{
    public interface IBookingRepository
    {
        public Task<Booking?> MakeBooking(int customerId, int ticketId, int numberOfTickets);
        public Task<List<BookingResultDto>> GetBookings(int customerId);
        public Task<Booking?> GetBookingById(int bookingId);
        public Task<Booking?> RemoveBooking(int bookingId);
        public Task<TimeSpan?> GetTimeDifference(Booking booking);
    }
}
