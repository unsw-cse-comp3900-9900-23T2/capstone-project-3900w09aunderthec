using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace EventManagementAPI.Models
{
    public class BookingTicket
    {
        [Key] 
        public int Id { get; set; }
        public int bookingId { get; set; }
        public Booking booking { get; set; }
        public int ticketId { get; set; }
        public Ticket ticket { get; set; }
        public int numberOfTickets { get; set; }
    }
}
