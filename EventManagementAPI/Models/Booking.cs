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
        public int ticketId { get; set; }
        public Ticket toTicket { get; set; }
        public int numberOfTickets { get; set; }
        public DateTime timeCreated { get; set; } = DateTime.Now;
    }
}
