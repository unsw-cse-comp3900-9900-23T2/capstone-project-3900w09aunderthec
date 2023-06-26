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

        public MySqlContext(DbContextOptions<MySqlContext> options) : base(options) { }
    }
}
