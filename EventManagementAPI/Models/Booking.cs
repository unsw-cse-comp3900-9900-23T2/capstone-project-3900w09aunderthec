using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace EventManagementAPI.Models
{
    public class Booking
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }
        public int customerId { get; set; }
        public Customer toCustomer { get; set; }
        // 1 represents credit/debit card; 2 represents digital wallet; 3 represent bank transfer
        public int paymentMethod { get; set; }
        public int gainedCredits { get; set; }
        public DateTime timeCreated { get; set; } = DateTime.Now;
        public ICollection<BookingTicket> bookingTickets { get; set; }
    }
}
