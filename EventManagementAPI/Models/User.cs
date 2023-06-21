using System;
namespace EventManagementAPI.Models
{
	public class User
	{
        public int? Id { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string Username { get; set; }
        public int? AddressId { get; set; }
        public string? ProfilePic { get; set; }
        public DateTime? TimeCreated { get; set; } = DateTime.UtcNow;
    }
}

