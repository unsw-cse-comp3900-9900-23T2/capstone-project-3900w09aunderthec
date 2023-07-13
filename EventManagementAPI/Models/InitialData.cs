namespace EventManagementAPI.Models
{
    public class InitialData
    {
        public string email { get; set; }
        public int? uid { get; set; }
        public bool isHost { get; set; }
        public int vipLevel { get; set; }
        public int loyaltyPoints { get; set;}
    }
}