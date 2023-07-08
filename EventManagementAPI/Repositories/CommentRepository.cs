using EventManagementAPI.Context;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using Microsoft.AspNetCore.JsonPatch;
using Microsoft.EntityFrameworkCore;

namespace EventManagementAPI.Repositories
{
    public class CommentRepository : ICommentRepository
    {
        private readonly MySqlContext _dbContext;

        public CommentRepository(MySqlContext dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task<List<Comment>> GetAllComments(string sortBy, int eventId)
        {
            IQueryable<Comment> query = _dbContext.comments.Where(c => c.eventId == eventId);

            switch (sortBy)
            {
                case "most recent":
                    query = query.OrderByDescending(c => c.createdTime);
                    break;
                case "most liked":
                    query = query.OrderByDescending(c => c.likes);
                    break;
                case "most disliked":
                    query = query.OrderByDescending(c => c.dislikes);
                    break;
                default:
                    break;
            }

            var comments =await query.ToListAsync();
            return comments;
        }

        public async Task<Comment?> GetCommentById(int id)
        {
            var comment = await _dbContext.comments.FindAsync(id);

            return comment;
        }

        public async Task<Comment> CreateComment(int customerId, int eventId, string comment)
        {
            var newComment = new Comment();
            newComment.comment = comment;

            var e = await _dbContext.events.FindAsync(eventId);
            newComment.eventId = eventId;
            newComment.eventShow = e;

            var customer = await _dbContext.customers.FindAsync(customerId);
            newComment.customerId = customerId;
            newComment.commenter = customer;

            _dbContext.comments.AddAsync(newComment);
            await _dbContext.SaveChangesAsync();
            return newComment;
        }

        public async Task<Comment> DeleteComment(int id)
        {
            var comment = await GetCommentById(id);

            _dbContext.comments.Remove(comment);

            await _dbContext.SaveChangesAsync();

            return comment;
        }
    }
}
