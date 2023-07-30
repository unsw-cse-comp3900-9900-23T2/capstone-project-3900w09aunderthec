using Microsoft.EntityFrameworkCore;
using EventManagementAPI.Models;

namespace EventManagementAPI.Context
{
    public class MySqlContext : DbContext
    {
        public DbSet<Event> Events { get; set; }
        public DbSet<Customer> Customers { get; set; }
        public DbSet<Hoster> Hosts { get; set; }
        public DbSet<Ticket> Tickets { get; set; }
        public DbSet<Booking> Bookings { get; set; }
        public DbSet<Comment> Comments { get; set; }
        public DbSet<CommentLike> CommentLikes { get; set; }
        public DbSet<CommentDislike> CommentDislikes { get; set; }
        public DbSet<Subscription> Subscriptions { get; set; }
        public DbSet<EventSaved> EventsSaved { get; set; }
        public DbSet<BookingTicket> BookingTickets { get; set; }

        public MySqlContext(DbContextOptions<MySqlContext> options) : base(options) { }
    }
}
