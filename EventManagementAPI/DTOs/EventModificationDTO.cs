using EventManagementAPI.Models;

namespace EventManagementAPI.DTOs
{
    public class EventModificationDTO
    {
        public int eventId { get; set; }
        public string? title { get; set; }
        public DateTime? eventTime { get; set; }
        public DateTime? createdTime { get; set; }
        public string? venue { get; set; }
        public string? description { get; set; }
        public bool? isDirectRefunds { get; set; }
        public bool? isPrivateEvent { get; set; }
        public String? tags { get; set; }
    }
}
