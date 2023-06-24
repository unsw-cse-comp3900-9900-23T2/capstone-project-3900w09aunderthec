using Microsoft.EntityFrameworkCore;
using EventManagementAPI.Models;

namespace EventManagementAPI.Context
{
    public class MySqlContext : DbContext
    {
        public DbSet<Event> Events { get; set; }
        public DbSet<Customer> Customers { get; set; }
        public DbSet<Address> Addresses { get; set; }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Address>()
                .HasOne(a => a.User)
                .WithOne(u => u.Address)
                .HasForeignKey<User>(u => u.AddressId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Address>()
                .HasOne(a => a.Event)
                .WithOne(e => e.Address)
                .HasForeignKey<Event>(e => e.AddressId)
                .OnDelete(DeleteBehavior.Restrict);
        }
        public MySqlContext(DbContextOptions<MySqlContext> options) : base(options) { }
    }
}
