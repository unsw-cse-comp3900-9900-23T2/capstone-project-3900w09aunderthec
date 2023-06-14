using System;
namespace EventManagementAPI.Models
{
	public class Customer : User
	{
        public string? PhoneNumber { get; set; }
        public DateTime? Birthday { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public List<int> Favourites { get; set; } = new List<int>();
        public List<int> Subscriptions { get; set; } = new List<int>();
    }
}

