using System.Collections.Generic;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using EventManagementAPI.DTOs;
using Microsoft.AspNetCore.JsonPatch;

namespace EventManagementAPI.Repositories
{
    public interface ICommentRepository
    {
        public Task<CommentListingDto> GetComments(string? sortBy, int? eventId, int? inReplyToComment);
        public Task<Comment?> GetCommentById(int id);
        public Task<Comment?> CreateComment(int customerId, int eventId, int? commentId, string comment);
        public Task<bool> isLikeComment(int uid, int commentId);
        public Task<bool> isDislikeComment(int uid, int commentId);
        public Task<string> ToggleLikeComment(int customerId, int commentId);
        public Task<string> ToggleDislikeComment(int customerId, int commentId);
        public Task<Comment> RetrieveComment(int commentId);
        public Task<Comment> PinComment(int commentId);
    }
}
