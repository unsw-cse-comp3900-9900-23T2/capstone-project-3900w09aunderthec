using System.Collections.Generic;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using EventManagementAPI.DTOs;

namespace EventManagementAPI.Repositories
{
    public interface IBookingRepository
    {
        public Task<int?> GetNumberOfTicketsInStock(int ticketId);
        public Task<double?> GetCreditMoney(int customerId, int hosterId);
        public Task<BookingCreationDto> MakeBooking(int customerId, Dictionary<string, int> bookingTickets, int paymentMethod);
        public Task<List<BookingResultDTO>> GetBookings(int customerId);
        public Task<Booking?> GetBookingById(int bookingId);
        public Task<Booking?> RemoveBooking(int bookingId);
        public Task<TimeSpan?> GetTimeDifference(Booking booking);
    }
}
