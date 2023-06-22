using System;
namespace EventManagementAPI.Models
{
	public class Event
	{
        public String? title { get; set; }
        public int eventId { get; set; }
        public DateTime time { get; set; }
        public String venue { get; set; }
        public String description { get; set; }
        public Enum refundPolicy { get; set; }
        public Boolean privateEvent { get; set; }
        public Double rating { get; set; }
        public List<Comment> comments { get; set; }
        public List<String> tags { get; set; }
        public List<Ticket> tickets { get; set; }
    }
}

