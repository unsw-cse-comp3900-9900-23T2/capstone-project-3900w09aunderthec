using System;
namespace EventManagementAPI.Models
{
	public abstract class User
	{
        public int uid { get; set; }
        public string email { get; set; }
        public string password { get; set; }
        public string username { get; set; }
    }
}

