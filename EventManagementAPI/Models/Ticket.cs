using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace EventManagementAPI.Models
{
    public class Ticket
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int ticketId { get; set; }

        [ForeignKey("Event")]
        public int eventIdRef { get; set; }
        [JsonIgnore]
        public Event toEvent { get; set; }
        public String name { get; set; }
        public Double price { get; set; }
        public int stock { get; set; }
        public DateTime availableTime { get; set; }
        public DateTime createdTime { get; set; } = DateTime.Now;
    }
}
