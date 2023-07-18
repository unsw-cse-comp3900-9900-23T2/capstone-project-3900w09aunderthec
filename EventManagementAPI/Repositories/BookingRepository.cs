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

        public async Task<Booking?> MakeBooking(int customerId, Dictionary<string, int> bookingTickets, int paymentMethod)
        {
            var customer = await _dbContext.customers.FindAsync(customerId);
            if (customer == null)
            {
                return null;
            }

            var booking = new Booking
            {
                customerId = customerId,
                toCustomer = customer,
                paymentMethod = paymentMethod,
            };

            var totalPrice = 0.0;

            foreach (KeyValuePair<string, int> ticketPair in bookingTickets)
            {
                string ticketIdString = ticketPair.Key;
                int ticketId = int.Parse(ticketIdString);
                int numberOfTickets = ticketPair.Value;
                var ticket = await _dbContext.tickets.FindAsync(ticketId);
                if (ticket == null)
                {
                    return null;
                }

                var newBookingTicket = new BookingTicket
                {
                    bookingId = booking.Id,
                    booking = booking,
                    ticketId = ticketId,
                    ticket = ticket,
                    numberOfTickets = numberOfTickets,
                };

                _dbContext.bookingTickets.Add(newBookingTicket);

                var subTotal = ticket.price * numberOfTickets;
                totalPrice += subTotal;

                ticket.stock -= numberOfTickets;
            }

            booking.gainedCredits = Convert.ToInt32(totalPrice) * 10;

            // customer gains loyalty points
            customer.loyaltyPoints += booking.gainedCredits;

            _dbContext.bookings.Add(booking);
             await _dbContext.SaveChangesAsync();

            return booking;
        }

        public async Task<List<BookingResultDto>> GetBookings(int customerId)
        {
            var bookings = await _dbContext.bookings
                .Where(b => b.customerId == customerId)
                .Include(b => b.bookingTickets)
                    .ThenInclude(t => t.ticket)
                        .ThenInclude(e => e.toEvent)
                .Select(b => new BookingResultDto
                {
                    booking = b,
                })
                .ToListAsync();

            return bookings;
        }

        public async Task<Booking?> GetBookingById(int bookingId)
        {
            var b = await _dbContext.bookings
                .Include(b => b.bookingTickets)
                    .ThenInclude(t => t.ticket)
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

            var tickets = await _dbContext.bookingTickets.Where(t => t.bookingId == bookingId).Include(t => t.ticket).ThenInclude(e => e.toEvent).ToListAsync();

            if (tickets.Count == 0)
            {
                return null;
            }

            var totalPrice = 0.0;

            foreach (BookingTicket bookingTicket in tickets)
            {
                var ticket = bookingTicket.ticket;
                if (ticket == null)
                {
                    return null;
                }

                ticket.stock += bookingTicket.numberOfTickets;

                totalPrice += (ticket.price * bookingTicket.numberOfTickets);

                _dbContext.bookingTickets.Remove(bookingTicket);
            }

            var e = tickets[0].ticket.toEvent;

            if (e == null)
            {
                return null;
            }

            var hoster = await _dbContext.hosts.FindAsync(e.hosterFK);

            if (hoster == null)
            {
                return null;
            }

            if (!e.isDirectRefunds)
            {
                var creditMoney = new CreditMoney
                {
                    customerId = booking.customerId,
                    toCustomer = customer,
                    hosterId = e.hosterFK,
                    toHoster = hoster,
                    creditAmount = totalPrice,
                };

                _dbContext.creditMoney.Add(creditMoney);
            } else
            {
                // do something to refund
            }

            _dbContext.bookings.Remove(booking);
            await _dbContext.SaveChangesAsync();

            return booking;
        }

        public async Task<TimeSpan?> GetTimeDifference(Booking booking)
        {
            var bookingTickets = await _dbContext.bookingTickets.Where(bt => bt.bookingId == booking.Id).ToListAsync();
            if (bookingTickets.Count == 0)
            {
                return null;
            }

            var ticket = await _dbContext.tickets.FindAsync(bookingTickets[0].ticketId);
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
    }
}
