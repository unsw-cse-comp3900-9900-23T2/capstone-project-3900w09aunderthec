using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
namespace EventManagementAPI.Models
{
	public class Customer : User
	{
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int customerId { get; set; }
        public int loyaltyPoints { get; set; } = 0;
        public int vipLevel { get; set; } = 0;
    }
}

