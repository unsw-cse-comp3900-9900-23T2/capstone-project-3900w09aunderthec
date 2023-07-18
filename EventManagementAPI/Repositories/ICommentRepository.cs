﻿using System.Collections.Generic;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using Microsoft.AspNetCore.JsonPatch;

namespace EventManagementAPI.Repositories
{
    public interface ICommentRepository
    {
        public Task<List<Comment?>> GetAllComments(string sortBy, int eventId, int? inReplyToComment);
        public Task<Comment?> GetCommentById(int id);
        public Task<Comment?> CreateComment(int customerId, int eventId, int? commentId, string comment);
        public Task<string> ToggleLikeComment(int customerId, int commentId);
        // public Task<bool> UndoLikedComment(int commentLikeId);
        public Task<string> ToggleDislikeComment(int customerId, int commentId);
        // public Task<bool> UndoDislikeComment(int commentDislikeId);
        public Task<Comment?> RetrieveComment(int commentId);
        // public Task<Reply?> Reply(int commenterId, int replierId, int commentId, string reply);
        // public Task<Reply?> RetrieveReply(int replyId);
    }
}
