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

        public async Task<int?> GetNumberOfTicketsInStock(int ticketId)
        {
            var ticket = await _dbContext.tickets.FindAsync(ticketId);
            if (ticket == null)
            {
                return null;
            }

            return ticket.stock;
        }

        public async Task<double?> GetCreditMoney(int customerId, int hosterId)
        {
            var creditMoney = await _dbContext.creditMoney.FirstOrDefaultAsync(c => c.customerId == customerId && c.hosterId == hosterId);

            if (creditMoney == null)
            {
                return null;
            }

            return creditMoney.creditAmount;
        }

        public async Task<Booking?> MakeBooking(int customerId, int ticketId, int numberOfTickets, int paymentMethod)
        {
            var customer = await _dbContext.customers.FindAsync(customerId);
            if (customer == null)
            {
                return null;
            }

            var ticket = await _dbContext.tickets.FindAsync(ticketId);
            if (ticket == null)
            {
                return null;
            }

            var booking = new Booking
            {
                customerId = customerId,
                toCustomer = customer,
                ticketId = ticketId,
                toTicket = ticket,
                numberOfTickets = numberOfTickets,
                paymentMethod = paymentMethod,
                gainedCredits = Convert.ToInt32(ticket.price * numberOfTickets) * 10,
            };

            // customer gains loyalty points
            customer.loyaltyPoints += booking.gainedCredits;

            // reduce number of tickets in stock
            ticket.stock -= numberOfTickets;

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

            var customer = await _dbContext.customers.FindAsync(booking.customerId);
            if (customer == null)
            {
                return null;
            }
            customer.loyaltyPoints -= booking.gainedCredits;

            var ticket = await _dbContext.tickets.FindAsync(booking.ticketId);
            if (ticket == null)
            {
                return null;
            }
            ticket.stock += booking.numberOfTickets;

            _dbContext.bookings.Remove(booking);
            await _dbContext.SaveChangesAsync();
            return booking;
        }

        public async Task<TimeSpan?> GetTimeDifference(Booking booking)
        {
            var ticket = await _dbContext.tickets.FindAsync(booking.ticketId);
            if (ticket == null)
            {
                return null;
            }

            var e = await _dbContext.events.FindAsync(ticket.eventIdRef);
            if (e == null)
            {
                return null;
            }

            var timeDifference = e.eventTime - DateTime.Now;

            return timeDifference;
        }

        public async Task<bool?> IsDirectRefunds(int bookingId)
        {
            var booking = await _dbContext.bookings.FindAsync(bookingId);
            if (booking == null)
            {
                return null;
            }

            var ticket = await _dbContext.tickets.FindAsync(booking.ticketId);
            if (ticket == null)
            {
                return null;
            }

            var e = await _dbContext.events.FindAsync(ticket.eventIdRef);
            if (e == null) {
                return null;
            }

            return e.isDirectRefunds;
        }

        public async Task<Booking?> NoDirectCancelBooking(int bookingId)
        {
            var booking = await _dbContext.bookings.FindAsync(bookingId);

            if (booking == null)
            {
                return null;
            }

            var customer = await _dbContext.customers.FindAsync(booking.customerId);
            if (customer == null)
            {
                return null;
            }
            customer.loyaltyPoints -= booking.gainedCredits;

            var ticket = await _dbContext.tickets.FindAsync(booking.ticketId);
            if (ticket == null)
            {
                return null;
            }
            ticket.stock += booking.numberOfTickets;

            _dbContext.bookings.Remove(booking);

            var e = await _dbContext.events.FindAsync(ticket.eventIdRef);
            if (e == null)
            {
                return null;
            }

            var creditMoney = await _dbContext.creditMoney.FirstOrDefaultAsync(c => c.customerId == customer.uid && c.hosterId == e.hosterFK);

            var hoster = await _dbContext.hosts.FindAsync(e.hosterFK);
            if (hoster == null)
            {
                return null;
            }

            if (creditMoney == null)
            {
                var newCreditMoney = new CreditMoney
                {
                    customerId = customer.uid,
                    toCustomer = customer,
                    hosterId = e.hosterFK,
                    toHoster = hoster,
                    creditAmount = Math.Round(ticket.price * booking.numberOfTickets, 2),
                };

                _dbContext.creditMoney.Add(newCreditMoney);
            } else
            {
                creditMoney.creditAmount += Math.Round(ticket.price * booking.numberOfTickets, 2);
            }

            await _dbContext.SaveChangesAsync();
            return booking;
        }
    }
}
