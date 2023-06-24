using System;
namespace EventManagementAPI.Models

// Don't worry about comments for Sprint 1

{
	public class Comment
	{
        public String text { get; set; }
        public User commenter { get; set; }
        public DateTime creationTime { get; set; }
    }
}
