using Microsoft.EntityFrameworkCore;
using EventManagementAPI.Models;

namespace EventManagementAPI.Context
{
    public class MySqlContext : DbContext
    {
        public DbSet<Event> Events { get; set; }
        public DbSet<Customer> Customers { get; set; }
        public DbSet<Address> Addresses { get; set; }
        public MySqlContext(DbContextOptions<MySqlContext> options) : base(options) { }
    }
}
