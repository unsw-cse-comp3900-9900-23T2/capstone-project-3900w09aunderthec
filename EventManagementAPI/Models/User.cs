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
        public int uid { get; set; }
        [Required]
        public string email { get; set; }
        [Required]
        public string username { get; set; }
        public DateTime createdTime { get; set; } = DateTime.Now;
    }
}

