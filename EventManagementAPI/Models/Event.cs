using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

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
        public DateTime time { get; set; }
        public String venue { get; set; }
        public String description { get; set; }
        public Boolean allowRefunds { get; set; }
        public Boolean privateEvent { get; set; }
        public Double? rating { get; set; }
        public String tags { get; set; }
    }
}
