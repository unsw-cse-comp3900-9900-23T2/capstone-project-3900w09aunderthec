using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace EventManagementAPI.Models
{
    public class Hoster : User
    {
    //     public ICollection<Event> events { get; set; } = new List<Event>();
        public string organisationName { get; set; }
    }
}
