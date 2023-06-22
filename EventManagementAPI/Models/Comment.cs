using System;
namespace EventManagementAPI.Models
{
	public class Comment
	{
        public String text { get; set; }
        public User commenter { get; set; }
        public DateTime creationTime { get; set; }
    }
}
