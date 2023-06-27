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
        public int CustomerId { get; set; }
        public Customer toCustomer { get; set; }
        public int TicketId { get; set; }
        public Ticket toTicket { get; set; }
        public int NumberOfTickets { get; set; }
        public DateTime TimeCreated { get; set; } = DateTime.Now;
    }
}
