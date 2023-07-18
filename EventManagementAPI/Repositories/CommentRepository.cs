using EventManagementAPI.Context;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using Microsoft.AspNetCore.Http.HttpResults;
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

        public async Task<List<Comment?>> GetAllComments(string sortBy, int eventId)
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

            if (comment == null)
            {
                throw new BadHttpRequestException("Comment does not exist");
            }

            return comment;
        }

        public async Task<Comment?> CreateComment(int customerId, int eventId, string comment)
        {
            var newComment = new Comment();
            newComment.comment = comment;

            var e = await _dbContext.events.FindAsync(eventId);
            newComment.eventId = eventId;
            newComment.eventShow = e;

            var customer = await _dbContext.customers.FindAsync(customerId);
            newComment.customerId = customerId;
            newComment.commenter = customer;

            _dbContext.comments.Add(newComment);
            await _dbContext.SaveChangesAsync();
            return newComment;
        }

        public async Task<Comment?> DeleteComment(int id)
        {
            var comment = await GetCommentById(id);

            if (comment == null)
            {
                throw new BadHttpRequestException("Comment does not exist");
            }

            _dbContext.comments.Remove(comment);

            await _dbContext.SaveChangesAsync();

            return comment;
        }

        public async Task<bool> LikeComment(int customerId, int commentId)
        {
            var customer = await _dbContext.customers.FindAsync(customerId);
            var comment = await _dbContext.comments.FindAsync(commentId);

            if (customer == null ||  comment == null)
            {
                return false;
            }

            var likeComment = new CommentLike();
            likeComment.customerId = customerId;
            likeComment.customer = customer;
            likeComment.commentId = commentId;
            likeComment.comment = comment;

            _dbContext.commentLikes.Add(likeComment);
            comment.likes++;
            await _dbContext.SaveChangesAsync();

            return true;
        }

        public async Task<bool> UndoLikedComment(int commentLikeId)
        {
            var commentLike = await _dbContext.commentLikes.FindAsync(commentLikeId);

            if (commentLike == null)
            {
                return false;
            }

            var commentId = commentLike.commentId;
            var comment = await _dbContext.comments.FindAsync(commentId);

            if ( comment != null )
            {
                comment.likes--;
            }
            
            _dbContext.commentLikes.Remove(commentLike);
            await _dbContext.SaveChangesAsync();

            return true;
        }

        public async Task<bool> DislikeComment(int customerId, int commentId)
        {
            var customer = await _dbContext.customers.FindAsync(customerId);
            var comment = await _dbContext.comments.FindAsync(commentId);

            if (customer == null || comment == null)
            {
                return false;
            }

            var likeComment = new CommentDislike();
            likeComment.customerId = customerId;
            likeComment.customer = customer;
            likeComment.commentId = commentId;
            likeComment.comment = comment;

            _dbContext.commentDislikes.Add(likeComment);
            comment.dislikes++;
            await _dbContext.SaveChangesAsync();

            return true;
        }

        public async Task<bool> UndoDislikeComment(int commentDislikeId)
        {
            var commentDislike = await _dbContext.commentDislikes.FindAsync(commentDislikeId);

            if (commentDislike == null)
            {
                return false;
            }

            var commentId = commentDislike.commentId;
            var comment = await _dbContext.comments.FindAsync(commentId);
            if (comment != null)
            {
                comment.dislikes--;
            }

            _dbContext.commentDislikes.Remove(commentDislike);
            await _dbContext.SaveChangesAsync();   

            return true;
        }

        public async Task<Comment?> RetrieveComment(int commentId)
        {
            var comment = await _dbContext.comments.FindAsync(commentId);

            if (comment == null )
            {
                throw new BadHttpRequestException("Comment does not exist");
            }

            _dbContext.comments.Remove(comment);

            await _dbContext.SaveChangesAsync();
            return comment;
        }

        public async Task<User?> GetUser(int uid)
        {

            User? user = await _dbContext.customers.FindAsync(uid);
            if (user == null)
            {
                user = await _dbContext.hosts.FindAsync(uid);
            }
            return user;
        }

        public async Task<Reply?> Reply(int commenterId, int replierId, int commentId, string reply)
        {
            User? commenter = await GetUser(commenterId); 
            if (commenter == null) {
                throw new BadHttpRequestException("Commenter does not exist");
            }

            User? replier = await GetUser(replierId);
            if (replier == null)
            {
                throw new BadHttpRequestException("Replier does not exist");
            }

            var comment = await _dbContext.comments.FindAsync(commentId);
            if (comment == null)
            {
                throw new BadHttpRequestException("Comment does not exist");
            }

            var newReply = new Reply
            {
                replier = replier,
                comment = comment,
                commenter = commenter,
                replierId = replierId,
                commentId = commentId,
                commenterId = commenterId,
                reply = reply,
            };

            _dbContext.replies.Add(newReply);
            await _dbContext.SaveChangesAsync();

            return newReply;
        }

        public async Task<Reply?> RetrieveReply(int replyId)
        {
            var reply = await _dbContext.replies.FindAsync(replyId);

            if (reply == null)
            {
                throw new BadHttpRequestException("Reply does not exist");
            }

            _dbContext.replies.Remove(reply);
            await _dbContext.SaveChangesAsync();

            return reply;
        }
    }
}
