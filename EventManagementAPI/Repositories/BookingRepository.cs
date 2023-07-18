using EventManagementAPI.Context;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using Microsoft.EntityFrameworkCore;
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
                throw new BadHttpRequestException("Customer does not exist");
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
                    throw new BadHttpRequestException("One of the ticket types does not exist, booking not made.");
                }

                if (ticket.stock - numberOfTickets < 0)
                {
                    throw new BadHttpRequestException(String.Format("Not enough stock to purchase {0} {1} tickets, only {3} remain. Booking not made", numberOfTickets, ticket.name, ticket.stock));
                }
            }

            foreach (KeyValuePair<string, int> ticketPair in bookingTickets)
            {
                string ticketIdString = ticketPair.Key;
                int ticketId = int.Parse(ticketIdString);
                int numberOfTickets = ticketPair.Value;
                var ticket = await _dbContext.tickets.FindAsync(ticketId);

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

        public async Task<List<BookingResultDTO>> GetBookings(int customerId)
        {

            var bookings = _dbContext.bookingTickets
                .Join(_dbContext.tickets,
                    bt => bt.ticketId,
                    t => t.ticketId,
                    (bt,t) => new
                    {
                        bt.booking,
                        t.toEvent
                    })
                .Where(c => c.booking.customerId == customerId)
                .Select(c => new BookingResultDTO
                {
                    booking = c.booking,
                    eventName = c.toEvent.title
                })
                .ToListAsync();

            return await bookings;
        }

        public async Task<Booking?> GetBookingById(int bookingId)
        {
            var b = await _dbContext.bookings
                .FirstOrDefaultAsync(b => b.Id == bookingId);

            return b;
        }

        public async Task<Booking?> RemoveBooking(int bookingId)
        {
            var booking = await _dbContext.bookings.FindAsync(bookingId);

            if (booking == null)
            {
                throw new BadHttpRequestException("Booking does not exist");
            }

            var customer = await _dbContext.customers.FindAsync(booking.customerId);
            customer.loyaltyPoints -= booking.gainedCredits;

            var bookingTickets = await _dbContext.bookingTickets.Where(t => t.bookingId == bookingId).ToListAsync();

            var e = bookingTickets[0].ticket.toEvent;
            if (e == null)
            {
                throw new BadHttpRequestException("The relevant event has been deleted. This should not be possible! - Deleting an event should auto refund and delete relevant bookings");
            }

            var totalPrice = 0.0;            

            foreach (BookingTicket bookingTicket in bookingTickets)
            {
                var ticket = bookingTicket.ticket;

                ticket.stock += bookingTicket.numberOfTickets;

                totalPrice += (ticket.price * bookingTicket.numberOfTickets);

                _dbContext.bookingTickets.Remove(bookingTicket);
            }

            var hoster = await _dbContext.hosts.FindAsync(e.hosterFK);

            if (!e.isDirectRefunds && (e.eventTime - DateTime.Now < new TimeSpan(7, 0, 0 ,0)))
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
