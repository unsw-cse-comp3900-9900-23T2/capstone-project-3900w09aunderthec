using EventManagementAPI.Context;
using EventManagementAPI.Models;
using EventManagementAPI.DTOs;
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
        /// Get a list comments based on optional sorting criteria including pinned comments
        /// </summary>
        /// <param name="sortBy"></param>
        /// <param name="eventId"></param>
        /// <param name="inReplyToComment"></param>
        /// <returns>
        /// A CommentListingDto object includes pinned comments and oridinary comments
        /// </returns>
        /// <exception cref="BadHttpRequestException"></exception>
        /// <exception cref="DbUpdateException"></exception>
        public async Task<CommentListingDto> GetComments(string? sortBy, int? eventId, int? replyToComment)
        {
            if (eventId is null && replyToComment is null)
            { throw new BadHttpRequestException("At least one of eventId, inReplyToComment must be specified"); }

            IQueryable<Comment> query = _dbContext.Comments.Where(c => c.commentId == replyToComment && c.eventId == eventId) ?? throw new DbUpdateException("Event or comment to reply to does not exist");

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

            var pinnedComments = await query.Where(c => c.isPinned).ToListAsync();
            var comments = await query.Where(c => c.isPinned == false).ToListAsync();

            var getCommentsDto = new CommentListingDto
            {
                PinnedComments = pinnedComments,
                Comments = comments,
            };

            return getCommentsDto;
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
            var comment = await _dbContext.Comments.FindAsync(id) ?? throw new KeyNotFoundException("Comment does not exist");
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
        public async Task<Comment?> CreateComment(int uid, int eventId, int? commentId, string comment)
        {
            var replyToComment = commentId.HasValue ? await GetCommentById(commentId.Value) : null;

            if (commentId.HasValue && replyToComment == null)
            {
                throw new KeyNotFoundException("reply to comment does not exist");
            }

            var e = await _dbContext.Events.FindAsync(eventId);
            User? user = await _dbContext.Customers.FindAsync(uid);

            if (e == null)
            {
                throw new KeyNotFoundException("relevant event does not exist");
            }

            if (user == null)
            {
                user ??= await _dbContext.Hosts.FindAsync(uid) ?? throw new KeyNotFoundException("no relevant user found");
                if (user.uid != e.hosterFK) throw new UnauthorizedAccessException("only this event hosters can reply");
            }

            var newComment = new Comment
            {
                comment = comment,
                eventId = eventId,
                eventShow = e,
                commenteruid = uid,
                commenter = user,
                commentId = commentId,
                replyTo = replyToComment,
            };

            _dbContext.Comments.Add(newComment);
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
            var customer = await _dbContext.Customers.FindAsync(customerId) ?? throw new KeyNotFoundException("Customer does not exist");
            var comment = await _dbContext.Comments.FindAsync(commentId) ?? throw new KeyNotFoundException("Comment does not exist");

            var existingLike = await _dbContext.CommentLikes.FirstOrDefaultAsync(l => l.customerId == customerId && l.commentId == commentId);

            if (existingLike is not null)
            {
                _dbContext.CommentLikes.Remove(existingLike);
                comment.likes--;
                await _dbContext.SaveChangesAsync();

                return "Like removed";
            }

            var likeComment = new CommentLike()
            {
                customerId = customerId,
                commentId = commentId,
            };

            _dbContext.CommentLikes.Add(likeComment);
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
            var customer = await _dbContext.Customers.FindAsync(customerId) ?? throw new KeyNotFoundException("Customer does not exist");
            var comment = await _dbContext.Comments.FindAsync(commentId) ?? throw new KeyNotFoundException("Comment does not exist");

            var existingDislike = await _dbContext.CommentDislikes.FirstOrDefaultAsync(l => l.customerId == customerId && l.commentId == commentId);

            if (existingDislike is not null)
            {
                _dbContext.CommentDislikes.Remove(existingDislike);
                comment.dislikes--;
                await _dbContext.SaveChangesAsync();

                return "Dislike removed";
            }

            var dislikeComment = new CommentDislike()
            {
                customerId = customerId,
                commentId = commentId,
            };

            _dbContext.CommentDislikes.Add(dislikeComment);
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
            var comment = await _dbContext.Comments.FindAsync(commentId) ?? throw new KeyNotFoundException("Comment does not exist");

            _dbContext.Comments.Remove(comment);
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
            var comment = await _dbContext.Comments.FindAsync(commentId) ?? throw new KeyNotFoundException("Comment does not exist");

            if (comment.replyTo != null)
            {
                throw new BadHttpRequestException("Only root comments can be pinned");
            }

            comment.isPinned = !comment.isPinned;
            _dbContext.Comments.Update(comment);
            await _dbContext.SaveChangesAsync();
            return comment;
        }
    }
}
