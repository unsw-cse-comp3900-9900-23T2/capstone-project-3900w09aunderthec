using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace EventManagementAPI.Models
{
    public class Event
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int eventId { get; set; }
        [ForeignKey("hosterFK")]
        [Required]
        [JsonIgnore]
        public Hoster host { get; set; }
        [Required]
        public int hosterFK { get; set; }
        public String title { get; set; }
        public String venue { get; set; }
        public DateTime eventTime { get; set; }
        public String description { get; set; }
        public Boolean isDirectRefunds { get; set; }
        public Boolean isPrivateEvent { get; set; }
        public Double? rating { get; set; }
        public String tags { get; set; }
        public int numberSaved { get; set; } = 0;
        public DateTime createdTime { get; set; } = DateTime.Now;
        [JsonIgnore]
        public ICollection<Ticket> tickets { get; set; } = new List<Ticket>();
        // [JsonIgnore]
        // public ICollection<Comment> comments { get; set; } = new List<Comment>();
    }
}
