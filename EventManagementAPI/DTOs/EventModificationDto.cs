using EventManagementAPI.Models;

namespace EventManagementAPI.DTOs
{
    public class EventModificationDto
    {
        public int eventId { get; set; }
        public string? title { get; set; }
        public string? venue { get; set; }
        public string? description { get; set; }
        public bool? allowRefunds { get; set; }
        public bool? privateEvent { get; set; }
        public String? tags { get; set; }
    }
}
