using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using EventManagementAPI.Models;

namespace EventManagementAPI.Models
{
	public abstract class User
	{
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }
        [Required]
        public string Email { get; set; }
        [Required]
        public string Password { get; set; }
        [Required]
        public string Username { get; set; }
        public string? PhoneNumber { get; set; }
        public int? AddressId { get; set; }
        public Address Address { get; set; }
        public DateTime TimeCreated { get; set; } = DateTime.UtcNow;
    }
}

