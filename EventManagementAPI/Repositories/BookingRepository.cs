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

        public async Task<Booking?> MakeBooking(int customerId, int ticketId, int numberOfTickets)
        {
            var customer = await _dbContext.customers.FindAsync(customerId);
            var ticket = await _dbContext.tickets.FindAsync(ticketId);

            var booking = new Booking
            {
                customerId = customerId,
                toCustomer = customer,
                ticketId = ticketId,
                toTicket = ticket,
                numberOfTickets = numberOfTickets,
            };

            _dbContext.bookings.Add(booking);
             await _dbContext.SaveChangesAsync();

            return booking;
        }

        public async Task<List<BookingResultDto>> GetBookings(int customerId)
        {
            var bookings = await _dbContext.bookings
                .Where(b => b.customerId == customerId)
                .Select(b => new BookingResultDto
                {
                    booking = b,
                    eventName = b.toTicket.toEvent.title,
                })
                .ToListAsync();

            return bookings;
        }

        public async Task<Booking?> GetBookingById(int bookingId)
        {
            var b = await _dbContext.bookings
                .Include(b => b.toTicket)
                    .ThenInclude(t => t.toEvent)
                .Include(b => b.toCustomer)
                .FirstOrDefaultAsync(b => b.Id == bookingId);

            return b;
        }

        public async Task<Booking?> RemoveBooking(int bookingId)
        {
            var booking = await _dbContext.bookings.FindAsync(bookingId);

            if (booking == null)
            {
                return null;
            }

            _dbContext.bookings.Remove(booking);
            await _dbContext.SaveChangesAsync();
            return booking;
        }
    }
}
