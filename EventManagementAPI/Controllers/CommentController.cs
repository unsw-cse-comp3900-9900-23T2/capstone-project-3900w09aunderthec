using Microsoft.AspNetCore.Mvc;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using Microsoft.AspNetCore.JsonPatch;
using Newtonsoft.Json;

namespace EventManagementAPI.Controllers
{
    public class GetCommentsRequestBody
    {
        public String sortby { get; set; }
    };

    public class CreateCommentsRequestBody
    {
        public int commenterId { get; set; }
        public int eventId { get; set; }
        public string comment { get; set; }
    }

    public class LikeCommentRequestBody
    {
        public int customerId { get; set; }
        public int commentId { get; set; }
    }

    public class UndoLikeCommentRequestBody
    {
        public int commentLikeId { get; set; }
    }

    public class UndoDislikedCommentRequestBody
    {
        public int commentDislikeId { get; set; }
    }

    [ApiController]
    [Route("api/[controller]")]
        public class CommentController : ControllerBase
        {
            private readonly ICommentRepository _commentRepository;

            public CommentController(ICommentRepository commentRepository)
            {
                _commentRepository = commentRepository;
            }

            [HttpGet]
            public async Task<IActionResult> GetEventComments([FromQuery] int eventId, [FromQuery] string sortby)
            {
                var eventComments = await _commentRepository.GetAllComments(sortby, eventId);
                return Ok(eventComments);
            }

            [HttpPost]
            public async Task<IActionResult> CreateEventComment([FromBody] CreateCommentsRequestBody requestBody)
            {
                var comment = requestBody.comment;
                var commenterId = requestBody.commenterId;
                var eventId = requestBody.eventId;

                var eventComment = await _commentRepository.CreateComment(commenterId, eventId, comment);
                return Ok(eventComment.eventId);
            }

            [HttpPost("likeComment")]
            public async Task<IActionResult> LikeComment([FromBody] LikeCommentRequestBody requestBody)
            {
                var commentId = requestBody.commentId;
                var customerId = requestBody.customerId;

                var likeComment = await _commentRepository.LikeComment(commentId, customerId);
                return Ok(likeComment);
            }

            [HttpPost("UndoLikeComment")]
            public async Task<IActionResult> UndoLikeComment([FromBody] UndoLikeCommentRequestBody requestBody)
            {
                var commentLikeId = requestBody.commentLikeId;

                var undoLikeComment = await _commentRepository.UndoLikedComment(commentLikeId);
                return Ok(undoLikeComment);
            }

            [HttpPost("DislikeComment")]
            public async Task<IActionResult> DislikeComment([FromBody] LikeCommentRequestBody requestBody)
            {
                var commentId = requestBody.commentId;
                var customerId = requestBody.customerId;

                var dislikeComment = await _commentRepository.DislikeComment(commentId, customerId);
                return Ok(dislikeComment);
            }

        [HttpPost("UndoDislikeComment")]
        public async Task<IActionResult> UndoDislikeComment([FromBody] UndoDislikedCommentRequestBody requestBody)
        {
            var commentDislikeId = requestBody.commentDislikeId;

            var undoDislikeComment = await _commentRepository.UndoDislikeComment(commentDislikeId);
            return Ok(undoDislikeComment);
        }

     }
}
