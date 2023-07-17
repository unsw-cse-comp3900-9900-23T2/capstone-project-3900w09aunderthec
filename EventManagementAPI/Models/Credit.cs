using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace EventManagementAPI.Models
{
	public class Credit
	{
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int creditId { get; set; }

        [ForeignKey("Hoster")]
        public int hosterIdRef { get; set; }
        public Hoster hoster { get; set; }

        [ForeignKey("Customer")]
        public int customerIdRef { get; set; }
        public Customer customer { get; set; }

        public Double creditValue { get; set; }
    }
}