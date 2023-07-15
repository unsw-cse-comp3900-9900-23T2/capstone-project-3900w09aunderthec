using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace EventManagementAPI.Models
{
    public class EventSaved
    {
        [Key]
        public int Id { get; set; }
        public int customerId { get; set; }
        public Customer customer { get; set; }
        public int eventId { get; set; }
        public Event eventShow { get; set; }
    }
}
