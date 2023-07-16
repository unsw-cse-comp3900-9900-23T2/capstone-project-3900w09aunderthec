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
        public Hoster host { get; set; }
        [Required]
        public int hosterFK { get; set; }
        public String title { get; set; }
        public String venue { get; set; }
        public DateTime eventTime { get; set; }
        public String description { get; set; }
        public Boolean allowRefunds { get; set; }
        public Boolean privateEvent { get; set; }
        public Double? rating { get; set; }
        public String tags { get; set; }
        public int numberSaved { get; set; } = 0;
        public DateTime createdTime { get; set; } = DateTime.Now;
        [JsonIgnore]
        public ICollection<Comment> comments { get; set; }
    }
}
