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
        public async Task<IActionResult> GetEventComments([FromQuery] int id, [FromQuery] string sortbyFromUrl)
        {
            var sortby = sortbyFromUrl;
            var eventId = id;

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
    }
}
