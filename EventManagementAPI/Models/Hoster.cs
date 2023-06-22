using System;
namespace EventManagementAPI.Models
{
	public class Hoster : User
	{
        public List<Event> myEvents { get; set; } = new List<Event>();
    }
}

