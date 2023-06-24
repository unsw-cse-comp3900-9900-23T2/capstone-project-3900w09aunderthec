using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
namespace EventManagementAPI.Models
{
    public class Hoster : User
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int hostId { get; set; }
        public ICollection<Event> events { get; set; }
        public ICollection<Subscription> subscriptions { get; set; }
        public string organisationName { get; set; }
    }
}
