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

    public class LikeDislikeCommentRequestBody
    {
        public int customerId { get; set; }
        public int commentId { get; set; }
    }

    public class PinCommentRequestBody
    {
        public int commentId { get; set; }
    }

    public class RetrieveRequestBody
    {
        public int commentId { get; set; }
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

        [HttpGet("ListComments")]
        public async Task<IActionResult> ListComments([FromQuery] int? eventId, [FromQuery] string? sortby, [FromQuery] int? replyToComment)
        {
            try
            {
                var eventComments = await _commentRepository.GetAllComments(sortby, eventId, replyToComment);
                return Ok(eventComments);
            } 
            catch (KeyNotFoundException e)
            {
                return NotFound(e.Message);
            } 
            catch (BadHttpRequestException e)
            {
                return BadRequest(e.Message);
            } 
            catch (Exception e)
            {
                return StatusCode(500, e.Message);
            }
        }

        [HttpGet("GetComment/{id}")]
        public async Task<IActionResult> GetCommentDetails(int id)
        {
            try
            {
                var comment = await _commentRepository.GetCommentById(id);
                return Ok(comment);
            } 
            catch (KeyNotFoundException e)
            {
                return NotFound(e.Message);
            } 
            catch (BadHttpRequestException e)
            {
                return BadRequest(e.Message);
            } 
            catch (Exception e)
            {
                return StatusCode(500, e.Message);
            }
        }
        
        [HttpPost("PostComment")]
        public async Task<IActionResult> CreateEventComment([FromBody] CreateCommentsRequestBody requestBody)
        {
            var comment = requestBody.comment;
            var commenterId = requestBody.commenterId;
            var commentId = requestBody.commentId;
            var eventId = requestBody.eventId;

            try
            {
                var eventComment = await _commentRepository.CreateComment(commenterId, eventId, commentId, comment);
                return Ok(eventComment);
            } 
            catch (KeyNotFoundException e)
            {
                return NotFound(e.Message);
            } 
            catch (BadHttpRequestException e)
            {
                return BadRequest(e.Message);
            } 
            catch (Exception e)
            {
                return StatusCode(500, e.Message);
            }
        }

        [HttpPost("ToggleLikeComment")]
        public async Task<IActionResult> ToggleLikeComment([FromBody] LikeDislikeCommentRequestBody requestBody)
        {
            var commentId = requestBody.commentId;
            var customerId = requestBody.customerId;

            try
            {
                var likeComment = await _commentRepository.ToggleLikeComment(commentId, customerId);
                return Ok(likeComment);
            } 
            catch (KeyNotFoundException e) {
                return NotFound(e.Message);
            } 
            catch (BadHttpRequestException e)
            {
                return BadRequest(e.Message);
            } 
            catch (Exception e)
            {
                return StatusCode(500, e.Message);
            }
        }

        [HttpPost("ToggleDislikeComment")]
        public async Task<IActionResult> ToggleDislikeComment([FromBody] LikeDislikeCommentRequestBody requestBody)
        {
            var commentId = requestBody.commentId;
            var customerId = requestBody.customerId;

            try
            {
                var dislikeComment = await _commentRepository.ToggleDislikeComment(commentId, customerId);
                return Ok(dislikeComment);
            } 
            catch (KeyNotFoundException e)
            {
                return NotFound(e.Message);
            } 
            catch (BadHttpRequestException e)
            {
                return BadRequest(e.Message);
            } 
            catch (Exception e)
            {
                return StatusCode(500, e.Message);
            }
        }

        [HttpPost("PinComment")]
        public async Task<IActionResult> PinComment([FromBody] PinCommentRequestBody requestBody)
        {
            var commentId = requestBody.commentId;

            try
            {
                var comment = await _commentRepository.PinComment(commentId);
                return Ok(comment);
            }
            catch (KeyNotFoundException e)
            {
                return NotFound(e.Message);
            }
            catch (BadHttpRequestException e)
            {
                return BadRequest(e.Message);
            }
            catch (Exception e)
            {
                return StatusCode(500, e.Message);
            }
        }

        [HttpDelete("RetrieveComment")]
        public async Task<IActionResult> RetrieveComment([FromBody] RetrieveRequestBody requestBody)
        {
            var commentId = requestBody.commentId;

            try
            {
                var comment = await _commentRepository.RetrieveComment(commentId);
                return Ok(comment);
            }
            catch (KeyNotFoundException e)
            {
                return NotFound(e.Message);
            }
            catch (BadHttpRequestException e)
            {
                return BadRequest(e.Message);
            }
            catch (Exception e)
            {
                return StatusCode(500, e.Message);
            }
        }
    }
}
