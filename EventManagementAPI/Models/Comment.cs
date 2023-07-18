using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace EventManagementAPI.Models
{
    public class Comment
    {
        [Key]
        public int Id { get; set; }
        public string comment { get; set; }
        public int customerId { get; set; }
        [JsonIgnore]
        public Customer commenter { get; set; }
        public int? commentId { get; set; }
        public Comment? inReplyTo { get; set; }
        public int eventId { get; set; }
        [JsonIgnore]
        public Event eventShow { get; set; }
        public int likes { get; set; } = 0;
        public int dislikes { get; set; } = 0;
        public DateTime createdTime { get; set; } = DateTime.Now;
        // [JsonIgnore]
        // public ICollection<Reply> replies { get; set; } = new List<Reply>();
    }
}
