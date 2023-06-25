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

        // [ForeignKey("Hoster")]
        // public int hostIdRef { get; set; }
        // public Hoster host { get; set; }

        public String title { get; set; }
        public DateTime time { get; set; }
        public String venue { get; set; }
        public String description { get; set; }
        public Boolean allowRefunds { get; set; }
        public Boolean privateEvent { get; set; }
        public Double? rating { get; set; }
        // public List<String> tags { get; set; } = new List<String>();
    }
}
