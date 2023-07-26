using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
namespace EventManagementAPI.Models
{
	public class Customer : User
	{
        public int loyaltyPoints { get; set; } = 0;
        public int availableLoyaltyPoints { get; set; } = 0;
        public int vipLevel { get; set; } = 0;
        public double creditMoney { get; set; } = 0;
    }
}
