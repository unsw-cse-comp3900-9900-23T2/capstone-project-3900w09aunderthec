using System.Collections.Generic;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using Microsoft.AspNetCore.JsonPatch;

namespace EventManagementAPI.Repositories
{
    public interface ICommentRepository
    {
        public Task<List<Comment>> GetAllComments(string sortBy, int eventId);
        public Task<Comment> GetCommentById(int id);
        public Task<Comment> CreateComment(int customerId, int eventId, string comment);
        public Task<Comment> DeleteComment(int id);
    }
}
