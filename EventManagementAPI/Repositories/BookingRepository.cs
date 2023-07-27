using EventManagementAPI.Context;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using Microsoft.EntityFrameworkCore;
using EventManagementAPI.DTOs;
using Microsoft.AspNetCore.Server.IIS.Core;

namespace EventManagementAPI.Repositories
{
    public class BookingRepository : IBookingRepository
    {
        private readonly MySqlContext _dbContext;

        public BookingRepository(MySqlContext dbContext)
        {
            _dbContext = dbContext;
        }

        /// <summary>
        /// Get the stock of a specific ticket
        /// </summary>
        /// <param name="ticketId"></param>
        /// <returns>
        /// An integer indicates the stock
        /// </returns>
        /// <exception cref="BadHttpRequestException"></exception>
        public async Task<int?> GetNumberOfTicketsInStock(int ticketId)
        {
            var ticket = await _dbContext.Tickes.FindAsync(ticketId);
            return ticket == null ? throw new BadHttpRequestException("Ticket type does not exist") : ticket.stock;
        }

        /// <summary>
        /// Make a customer booking
        /// </summary>
        /// <param name="customerId"></param>
        /// <param name="bookingTickets"></param>
        /// <param name="paymentMethod"></param>
        /// <returns>
        /// A BookingCreationDto that contains the booking and payment information
        /// </returns>
        /// <exception cref="BadHttpRequestException"></exception>
        /// <exception cref="KeyNotFoundException"></exception>
        public async Task<BookingCreationDto> MakeBooking(int customerId, Dictionary<string, int> bookingTickets, int paymentMethod)
        {
            if (customerId <= 0 || bookingTickets == null || bookingTickets.Count == 0 || paymentMethod <= 0)
            {
                throw new BadHttpRequestException("Invalid input data");
            }

            var customer = await _dbContext.Customers.FindAsync(customerId) ?? throw new KeyNotFoundException("Customer does not exist");
            var booking = new Booking
            {
                customerId = customerId,
                toCustomer = customer,
                paymentMethod = paymentMethod,
            };
            foreach (KeyValuePair<string, int> ticketPair in bookingTickets)
            {
                string ticketIdString = ticketPair.Key;
                int ticketId = int.Parse(ticketIdString);
                int numberOfTickets = ticketPair.Value;
                var ticket = await _dbContext.Tickes.FindAsync(ticketId) ?? throw new KeyNotFoundException("One of the ticket types does not exist, booking not made.");
                if (ticket.stock - numberOfTickets < 0)
                {
                    throw new BadHttpRequestException(String.Format("Not enough stock to purchase {0} {1} tickets, only {3} remain. Booking not made", numberOfTickets, ticket.name, ticket.stock));
                }
            }

            double totalPrice = await CalculateTotalPrice(bookingTickets, booking);
            var vipLevel = customer.vipLevel;
            var loyaltyPoints = customer.availableLoyaltyPoints;
            // every 10 vip levels can get 1% off
            // maximum 15% off
            // minimum 0
            var discountPercentage = Math.Clamp((vipLevel / 10) * 0.01, 0, 0.15);

            // use loyalty points to get discount
            // one point equals one cent
            var discount = totalPrice * discountPercentage;

            booking.loyaltyPointsEarned = Convert.ToInt32(totalPrice) * 10;

            // customer gains loyalty points
            customer.loyaltyPoints += booking.loyaltyPointsEarned;
            customer.vipLevel = customer.loyaltyPoints / 1000;

            // use credit money for payment
            double creditMoneyUsed;
            if (totalPrice > customer.creditMoney)
            {
                creditMoneyUsed = customer.creditMoney;
                customer.creditMoney = 0;
                totalPrice -= customer.creditMoney;
            } else
            {
                creditMoneyUsed = totalPrice;
                customer.creditMoney -= creditMoneyUsed;
                totalPrice = 0;
            }

            booking.creditMoneyUsed = creditMoneyUsed;
            booking.totalPricePayed = totalPrice;

            _dbContext.Bookings.Add(booking);
             await _dbContext.SaveChangesAsync();

            var bookingCreation = new BookingCreationDto {
                booking = booking,
                creditMoneyUsed = creditMoneyUsed,
                totalPrice = totalPrice,
                discountGet = discount,
                newLoyaltyPoints = customer.loyaltyPoints,
                newVipLevel = customer.vipLevel,
            };

            return bookingCreation;
        }

        /// <summary>
        /// Get the total price that the customer should pay
        /// </summary>
        /// <param name="bookingTickets"></param>
        /// <param name="booking"></param>
        /// <returns>
        /// A double value that indicates the amount of money that the customer should pay
        /// </returns>
        /// <exception cref="KeyNotFoundException"></exception>
        private async Task<double> CalculateTotalPrice(Dictionary<string, int> bookingTickets, Booking booking)
        {
            var totalPrice = 0.0;

            foreach (KeyValuePair<string, int> ticketPair in bookingTickets)
            {
                string ticketIdString = ticketPair.Key;
                int ticketId = int.Parse(ticketIdString);
                int numberOfTickets = ticketPair.Value;
                var ticket = await _dbContext.Tickes.FindAsync(ticketId) ?? throw new KeyNotFoundException("ticket not found");

                var newBookingTicket = new BookingTicket
                {
                    bookingId = booking.Id,
                    booking = booking,
                    ticketId = ticketId,
                    ticket = ticket,
                    numberOfTickets = numberOfTickets,
                };

                _dbContext.BookingTickets.Add(newBookingTicket);

                var subTotal = ticket.price * numberOfTickets;
                totalPrice += subTotal;

                ticket.stock -= numberOfTickets;
            }

            await _dbContext.SaveChangesAsync();

            return totalPrice;
        }

        /// <summary>
        /// Get a list of customer bookings
        /// </summary>
        /// <param name="customerId"></param>
        /// <returns>
        /// A list of BookingResultDTo which includes booking and event details
        /// </returns>
        public async Task<List<BookingResultDTO>> GetBookings(int customerId)
        {

            var bookings = _dbContext.BookingTickets
                .Join(_dbContext.Tickes,
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
                    eventName = c.toEvent
                })
                .ToListAsync();

            return await bookings;
        }

        /// <summary>
        /// Get the details of a booking
        /// </summary>
        /// <param name="bookingId"></param>
        /// <returns>
        /// A booking object
        /// </returns>
        public async Task<Booking?> GetBookingById(int bookingId)
        {
            var b = await _dbContext.Bookings
                .FirstOrDefaultAsync(b => b.Id == bookingId);

            return b;
        }

        /// <summary>
        /// Cancel customer booking
        /// </summary>
        /// <param name="bookingId"></param>
        /// <returns>
        /// The Booking that the customer cancelled
        /// </returns>
        /// <exception cref="KeyNotFoundException"></exception>
        public async Task<Booking?> RemoveBooking(int bookingId)
        {
            var booking = await _dbContext.Bookings.FindAsync(bookingId) ?? throw new KeyNotFoundException("Booking does not exist");
            var customer = await _dbContext.Customers.FindAsync(booking.customerId) ?? throw new KeyNotFoundException("customer not found");
            customer.loyaltyPoints -= booking.loyaltyPointsEarned;
            customer.vipLevel = customer.loyaltyPoints / 1000;

            var bookingTickets = await _dbContext.BookingTickets.Where(t => t.bookingId == bookingId).ToListAsync();

            var e = bookingTickets[0].ticket.toEvent ?? throw new KeyNotFoundException("The relevant event has been deleted. This should not be possible! - Deleting an event should auto refund and delete relevant bookings");        

            foreach (BookingTicket bookingTicket in bookingTickets)
            {
                var ticket = await _dbContext.Tickes.FindAsync(bookingTicket.ticketId) ?? throw new KeyNotFoundException("ticket does not exist");

                ticket.stock += bookingTicket.numberOfTickets;

                _dbContext.BookingTickets.Remove(bookingTicket);
            }

            if (e.isDirectRefunds)
            {
                customer.creditMoney += booking.creditMoneyUsed;
                // do something and refund money
            } else
            {
                customer.creditMoney += booking.totalPricePayed;
            }

            _dbContext.Bookings.Remove(booking);
            await _dbContext.SaveChangesAsync();

            return booking;
        }

        /// <summary>
        /// Get the time span between the current time and the event time
        /// </summary>
        /// <param name="booking"></param>
        /// <returns>
        /// A TimeSpan object
        /// </returns>
        /// <exception cref="KeyNotFoundException"></exception>
        public async Task<TimeSpan?> GetTimeDifference(Booking booking)
        {
            var bookingTickets = await _dbContext.BookingTickets.Where(bt => bt.bookingId == booking.Id).ToListAsync();
            if (bookingTickets.Count == 0) throw new KeyNotFoundException("no relevant booking tickets found");

            var ticket = await _dbContext.Tickes.FindAsync(bookingTickets[0].ticketId) ?? throw new KeyNotFoundException("ticket not found");
            var e = await _dbContext.Events.FindAsync(ticket.eventIdRef) ?? throw new KeyNotFoundException("event not found");

            var timeDifference = e.eventTime - DateTime.Now;
            return timeDifference;
        }
    }
}
