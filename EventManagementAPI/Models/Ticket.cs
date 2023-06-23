using System;
namespace EventManagementAPI.Models
{
	public class Ticket
	{
        public String name { get; set; }
        public Event toEvent { get; set; }
        public Double price { get; set; }
    }
}
