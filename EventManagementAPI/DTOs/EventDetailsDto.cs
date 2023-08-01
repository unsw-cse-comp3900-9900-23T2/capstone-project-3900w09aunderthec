using EventManagementAPI.Models;

namespace EventManagementAPI.DTOs
{
    public class EventDetailsDto
    {
        public int eventId { get; set; }
        public int hosterFK { get; set; }
        public string title { get; set; }
        public string venue { get; set; }
        public DateTime eventTime { get; set; }
        public string description { get; set; }
        public bool isDirectRefunds { get; set; }
        public bool isPrivateEvent { get; set; }
        public double rating { get; set; }
        public string tags { get; set; }
        public int numberSaved { get; set; }
        public DateTime createdTime { get; set; }
        public double cheapestPrice { get; set; }
    }
}
