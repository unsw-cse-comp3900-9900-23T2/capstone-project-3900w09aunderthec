using System;
namespace EventManagementAPI.Models
{
	public class Customer : User
	{
        public DateTime? Birthday { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
    }
}

