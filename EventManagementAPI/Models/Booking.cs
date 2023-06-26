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
        public Customer Customer { get; set; }
        public Ticket Ticket { get; set; }
        public int NumberOfTickets { get; set; }
        public int TimeCreated { get; set; }
    }
}
