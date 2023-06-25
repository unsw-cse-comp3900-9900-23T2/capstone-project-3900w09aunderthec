using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
namespace EventManagementAPI.Models
{
	public class Subscription
	{
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int subscriptionId { get; set; }

        [ForeignKey("Event")]
        public int eventIdRef { get; set; }
        public Event toEvent { get; set; }

        [ForeignKey("Customer")]
        public int customerIdRef { get; set; }
        public Customer customer { get; set; }
    }
}