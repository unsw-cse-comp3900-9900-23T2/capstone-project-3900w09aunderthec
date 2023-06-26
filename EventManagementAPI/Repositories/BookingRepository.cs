using EventManagementAPI.Context;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using Microsoft.EntityFrameworkCore;
using System.Security.Cryptography.X509Certificates;
using EventManagementAPI.DTOs;

namespace EventManagementAPI.Repositories
{
    public class BookingRepository : IBookingRepository
    {
        private readonly MySqlContext _dbContext;

        public BookingRepository(MySqlContext dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task MakeBooking(Booking b)
        {
            _dbContext.bookings.Add(b);
             await _dbContext.SaveChangesAsync();
        }

        public async Task<List<BookingResultDto>> GetBookings(int customerId)
        {
            var bookings = await _dbContext.bookings
                .Where(b => b.CustomerId == customerId)
                .Select(b => new BookingResultDto
                {
                    booking = b,
                    eventName = b.toTicket.toEvent.title,
                })
                .ToListAsync();

            return bookings;
        }
    }
}
