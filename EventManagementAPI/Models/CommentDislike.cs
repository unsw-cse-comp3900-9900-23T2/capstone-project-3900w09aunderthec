using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace EventManagementAPI.Models
{
    public class CommentDislike
    {
        [Key]
        public int Id { get; set; }
        public int customerId { get; set; }
        public Customer customer { get; set; }
        public int commentId { get; set; }
        public Comment comment { get; set; }
    }
}
