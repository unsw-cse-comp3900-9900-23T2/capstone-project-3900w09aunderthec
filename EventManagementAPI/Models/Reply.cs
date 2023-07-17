using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace EventManagementAPI.Models
{
    public class Reply
    {
        [Key] 
        public int id { get; set; }
        public string reply { get; set; }
        public int replierId { get; set; }
        [JsonIgnore]
        public User replier { get; set; }
        public int commenterId { get; set; }
        [JsonIgnore]
        public User commenter { get; set; }
        public int commentId { get; set; }
        [JsonIgnore]
        public Comment comment { get; set; }
        public DateTime createdTime { get; set; } = DateTime.Now;
    }
}
