using System;
namespace EventManagementAPI.Models
{
	public class Customer : User
	{
        public int loyaltyPoints { get; set; } = 0;
        public int vipLevel { get; set; } = 0;
        public List<Ticket> eventTickets { get; set; } = new List<Ticket>();
        public List<Hoster> hostSubscriptions { get; set; } = new List<Hoster>();
    }
}

