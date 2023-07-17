using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace EventManagementAPI.Models
{
    public class CreditMoney
    {
        [Key]
        public int Id { get; set; }
        public int customerId { get; set; }
        public Customer toCustomer { get; set; }
        public int hosterId { get; set; }
        public Hoster toHoster { get; set; }
        public double creditAmount { get; set; }
    }
}
