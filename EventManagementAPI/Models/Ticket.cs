using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace EventManagementAPI.Models
{
    public class Ticket
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int ticketId { get; set; }

        [ForeignKey("Event")]
        public int eventIdRef { get; set; }
        public Event toEvent { get; set; }

        public String name { get; set; }
        public Double price { get; set; }
    }
}
