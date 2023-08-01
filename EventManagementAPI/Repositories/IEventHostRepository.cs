using System.Collections.Generic;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using EventManagementAPI.DTOs;

namespace EventManagementAPI.Repositories
{
    public interface IEventHostRepository
    {
        Task<List<Hoster>> GetAllEventHosts();
        public Task<Hoster?> GetHosterById(int hosterId);
        public List<Customer> GetBuyers(int eventId);
        public Task<List<Customer>> GetSubscribers(int hosterId, DateTime time);
        public Task<List<TicketSoldDto>> GetTicketsSold(int hosterId, DateTime time);
        public Task<double> GetPercentageBeaten(int hosterId, string rankBy);
    }
}
