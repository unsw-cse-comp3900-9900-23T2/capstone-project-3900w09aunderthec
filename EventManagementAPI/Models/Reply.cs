using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace EventManagementAPI.Models
{
    public class Reply
    {
        [Key] 
        public int Id { get; set; }
        public string reply { get; set; }
        public int replierId { get; set; }
        public User replier { get; set; }
        public int commmentId { get; set; }
        public Comment comment { get; set; }
    }
}
