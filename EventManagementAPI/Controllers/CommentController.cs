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
        public int? commentId { get; set; }
        public string comment { get; set; }
    }

    public class GetCommentRequestBody
    {
        public int commentId { get; set; }
    }

    public class LikeDislikeCommentRequestBody
    {
        public int customerId { get; set; }
        public int commentId { get; set; }
    }

    // public class UndoLikeCommentRequestBody
    // {
    //     public int commentLikeId { get; set; }
    // }

    // public class UndoDislikedCommentRequestBody
    // {
    //     public int commentDislikeId { get; set; }
    // }

    public class RetrieveCommentBody
    {
        public int commentId { get; set; }
    }

    // public class ReplyRequestBody
    // {
    //     public int commenterId { get; set; }
    //     public int replierId { get; set; }
    //     public int commentId { get; set; }
    //     public string reply { get; set; }
    // }

    // public class RetrieveReplyRequestBody
    // {
    //     public int replyId { get; set; }
    // }

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
        public async Task<IActionResult> GetEventComments([FromQuery] int eventId, [FromQuery] string sortby, [FromQuery] int? inReplyToComment)
        {
            var eventComments = await _commentRepository.GetAllComments(sortby, eventId, inReplyToComment);
            return Ok(eventComments);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetCommentDetails(int id)
        {
            var comment = await _commentRepository.GetCommentById(id);

            if (comment == null)
            {
                return NotFound();
            }

            return Ok(comment);
        }
        
        [HttpPost]
        public async Task<IActionResult> CreateEventComment([FromBody] CreateCommentsRequestBody requestBody)
        {
            var comment = requestBody.comment;
            var commenterId = requestBody.commenterId;
            var commentId = requestBody.commentId;
            var eventId = requestBody.eventId;

            var eventComment = await _commentRepository.CreateComment(commenterId, eventId, commentId, comment);
            return Ok(eventComment);
        }

        [HttpPost("ToggleLikeComment")]
        public async Task<IActionResult> ToggleLikeComment([FromBody] LikeDislikeCommentRequestBody requestBody)
        {
            var commentId = requestBody.commentId;
            var customerId = requestBody.customerId;

            var likeComment = await _commentRepository.ToggleLikeComment(commentId, customerId);
            return Ok(likeComment);
        }

    //     [HttpDelete("DecrementLikeComment")]
    //     public async Task<IActionResult> DecrementLikeComment([FromBody] UndoLikeCommentRequestBody requestBody)
    //     {
    //         var commentLikeId = requestBody.commentLikeId;

    //         var undoLikeComment = await _commentRepository.UndoLikedComment(commentLikeId);
    //         return Ok(undoLikeComment);
    //    }

       [HttpPost("ToggleDislikeComment")]
       public async Task<IActionResult> ToggleDislikeComment([FromBody] LikeDislikeCommentRequestBody requestBody)
       {
            var commentId = requestBody.commentId;
            var customerId = requestBody.customerId;

            var dislikeComment = await _commentRepository.ToggleDislikeComment(commentId, customerId);
            return Ok(dislikeComment);
        }

        // [HttpDelete("DecrementDislikeComment")]
        // public async Task<IActionResult> DecrementDislikeComment([FromBody] UndoDislikedCommentRequestBody requestBody)
        // {
        //     var commentDislikeId = requestBody.commentDislikeId;

        //     var undoDislikeComment = await _commentRepository.UndoDislikeComment(commentDislikeId);
        //     return Ok(undoDislikeComment);
        // }

        [HttpDelete("RetrieveComment")]
        public async Task<IActionResult> RetrieveComment([FromBody] RetrieveCommentBody requestBody)
        {
            var commentId = requestBody.commentId;
            var retrieveCommentResult = await _commentRepository.RetrieveComment(commentId);

            if (retrieveCommentResult == null)
            {
                return NotFound();
            }

            return Ok(retrieveCommentResult);
        }

        // [HttpPost("Reply")]
        // public async Task<IActionResult> Reply([FromBody] ReplyRequestBody requestBody)
        // {
        //     var commenterId = requestBody.commenterId;
        //     var replierId = requestBody.replierId;
        //     var commentId = requestBody.commentId;
        //     var reply = requestBody.reply;

        //     var newReply = await _commentRepository.Reply(commenterId, replierId, commentId, reply);
        //     if (newReply == null)
        //     {
        //         return NotFound();
        //     }

        //     return Ok(newReply.id);
        // }

        // [HttpDelete("RetrieveReply")]
        // public async Task<IActionResult> RetrieveReply([FromBody] RetrieveReplyRequestBody requestBody)
        // {
        //     var replyId = requestBody.replyId;

        //     var retrieveReplyResult = await _commentRepository.RetrieveReply(replyId);
        //     if (retrieveReplyResult == null)
        //     {
        //         return NotFound();
        //     }

        //     return Ok(retrieveReplyResult);
        // }

    }
}
