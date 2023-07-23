using EventManagementAPI.Context;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.JsonPatch;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging.Abstractions;

namespace EventManagementAPI.Repositories
{
    public class CommentRepository : ICommentRepository
    {
        private readonly MySqlContext _dbContext;

        public CommentRepository(MySqlContext dbContext)
        {
            _dbContext = dbContext;
        }

        /// <summary>
        /// Get a list comments based on optional sorting criteria
        /// </summary>
        /// <param name="sortBy"></param>
        /// <param name="eventId"></param>
        /// <param name="inReplyToComment"></param>
        /// <returns>
        /// A list of Comment objects that are in specified order
        /// </returns>
        /// <exception cref="BadHttpRequestException"></exception>
        /// <exception cref="DbUpdateException"></exception>
        public async Task<List<Comment>> GetAllComments(string? sortBy, int? eventId, int? replyToComment)
        {
            if (eventId is null && replyToComment is null)
            { throw new BadHttpRequestException("At least one of eventId, inReplyToComment must be specified");}

            IQueryable<Comment> query = _dbContext.comments.Where(c => c.commentId == replyToComment || c.eventId == eventId) ?? throw new DbUpdateException("Event or comment to reply to does not exist");

            switch (sortBy)
            {
                case "soonest":
                    query = query.OrderByDescending(c => c.createdTime);
                    break;
                case "most_liked":
                    query = query.OrderByDescending(c => c.likes);
                    break;
                case "most_disliked":
                    query = query.OrderByDescending(c => c.dislikes);
                    break;
                default:
                    break;
            }

            var comments = await query.ToListAsync();
            return comments;
        }

        /// <summary>
        /// Get details of a comment by id
        /// </summary>
        /// <param name="id"></param>
        /// <returns>
        /// A Comment object whose id matches the parameter
        /// </returns>
        /// <exception cref="KeyNotFoundException"></exception>
        public async Task<Comment?> GetCommentById(int id)
        {
            var comment = await _dbContext.comments.FindAsync(id) ?? throw new KeyNotFoundException("Comment does not exist");
            return comment;
        }

        /// <summary>
        /// Customers can create comments
        /// </summary>
        /// <param name="customerId"></param>
        /// <param name="eventId"></param>
        /// <param name="commentId"></param>
        /// <param name="comment"></param>
        /// <returns>
        /// A Comment object that is newly created
        /// </returns>
        /// <exception cref="KeyNotFoundException"></exception>
        public async Task<Comment?> CreateComment(int customerId, int eventId, int? commentId, string comment)
        {
            var replyToComment = commentId.HasValue ? await GetCommentById(customerId) : null;
            
            if (commentId.HasValue && replyToComment == null)
            {
                throw new KeyNotFoundException("reply to comment does not exist");
            }

            var e = await _dbContext.events.FindAsync(eventId);
            var customer = await _dbContext.customers.FindAsync(customerId);

            if (e == null)
            {
                throw new KeyNotFoundException("relevant event does not exist");
            }

            if (customer == null)
            {
                throw new KeyNotFoundException("revelant customer does not exist");
            }

            var newComment = new Comment
            {
                comment = comment,
                eventId = eventId,
                eventShow = e,
                customerId = customerId,
                commenter = customer,
                commentId = commentId,
                replyTo = replyToComment,
            };

            _dbContext.comments.Add(newComment);
            await _dbContext.SaveChangesAsync();
            return newComment;
        }

        /// <summary>
        /// Like or cancel like a comment
        /// </summary>
        /// <param name="customerId"></param>
        /// <param name="commentId"></param>
        /// <returns>
        /// A string that indicates whether a user has liked a comment or cancelled like
        /// </returns>
        /// <exception cref="KeyNotFoundException"></exception>
        public async Task<string> ToggleLikeComment(int customerId, int commentId)
        {
            var customer = await _dbContext.customers.FindAsync(customerId) ?? throw new KeyNotFoundException("Customer does not exist");
            var comment = await _dbContext.comments.FindAsync(commentId) ?? throw new KeyNotFoundException("Comment does not exist");

            var existingLike = await _dbContext.commentLikes.FirstOrDefaultAsync(l => l.customerId == customerId && l.commentId == commentId);

            if (existingLike is not null)
            {
                _dbContext.commentLikes.Remove(existingLike);
                comment.likes--;
                await _dbContext.SaveChangesAsync();

                return "Like removed";
            }

            var likeComment = new CommentLike()
            {
                customerId = customerId,
                commentId = commentId,
            };

            _dbContext.commentLikes.Add(likeComment);
            comment.likes++;
            await _dbContext.SaveChangesAsync();

            return "Comment liked";
        }

        /// <summary>
        /// Dislike or cancel dislike a comment
        /// </summary>
        /// <param name="customerId"></param>
        /// <param name="commentId"></param>
        /// <returns>
        /// A string that indicates whether a user has disliked a comment or cancelled dislike
        /// </returns>
        /// <exception cref="KeyNotFoundException"></exception>
        public async Task<string> ToggleDislikeComment(int customerId, int commentId)
        {
            var customer = await _dbContext.customers.FindAsync(customerId) ?? throw new KeyNotFoundException("Customer does not exist");
            var comment = await _dbContext.comments.FindAsync(commentId) ?? throw new KeyNotFoundException("Comment does not exist");

            var existingDislike = await _dbContext.commentDislikes.FirstOrDefaultAsync(l => l.customerId == customerId && l.commentId == commentId);

            if (existingDislike is not null)
            {
                _dbContext.commentDislikes.Remove(existingDislike);
                comment.dislikes--;
                await _dbContext.SaveChangesAsync();

                return "Dislike removed";
            }

            var dislikeComment = new CommentDislike()
            {
                customerId = customerId,
                commentId = commentId,
            };

            _dbContext.commentDislikes.Add(dislikeComment);
            comment.dislikes++;
            await _dbContext.SaveChangesAsync();
            
            return "Comment disliked";
        }

        /// <summary>
        /// Customer can delete a comment he has made
        /// </summary>
        /// <param name="commentId"></param>
        /// <returns>
        /// The Comment that has deleted
        /// </returns>
        /// <exception cref="KeyNotFoundException"></exception>
        public async Task<Comment> RetrieveComment(int commentId)
        {
            var comment = await _dbContext.comments.FindAsync(commentId) ?? throw new KeyNotFoundException("Comment does not exist");

            _dbContext.comments.Remove(comment);
            await _dbContext.SaveChangesAsync();
            return comment;
        }

        /// <summary>
        /// Event hoster can pin a comment
        /// </summary>
        /// <param name="commentId"></param>
        /// <returns>
        /// The Comment object that has been pinned
        /// </returns>
        /// <exception cref="KeyNotFoundException"></exception>
        /// <exception cref="BadHttpRequestException"></exception>
        public async Task<Comment> PinComment(int commentId)
        {
            var comment = await _dbContext.comments.FindAsync(commentId) ?? throw new KeyNotFoundException("Comment does not exist");

            if (comment.replyTo != null)
            {
                throw new BadHttpRequestException("Only root comments can be pinned");
            }

            comment.isPinned = !comment.isPinned;
            _dbContext.comments.Update(comment);
            await _dbContext.SaveChangesAsync();
            return comment;
        }
    }
}
