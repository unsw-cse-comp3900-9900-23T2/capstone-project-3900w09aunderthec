using Microsoft.EntityFrameworkCore;
using EventManagementAPI.Models;

namespace EventManagementAPI.Context
{
    public class MySqlContext : DbContext
    {
        public DbSet<Event> events { get; set; }
        public DbSet<Customer> customers { get; set; }
        public DbSet<Hoster> hosts { get; set; }
        public DbSet<Ticket> tickets { get; set; }
        public DbSet<Booking> bookings { get; set; }
        public DbSet<Comment> comments { get; set; }
        public DbSet<CommentLike> commentLikes { get; set; }
        public DbSet<CommentDislike> commentDislikes { get; set; }
        public DbSet<Subscription> subscriptions { get; set; }
        public DbSet<EventSaved> eventsSaved { get; set; }
        public DbSet<Reply> replies { get; set; }
        public DbSet<CreditMoney> creditMoney { get; set; }

        public MySqlContext(DbContextOptions<MySqlContext> options) : base(options) { }
    }
}
