using EventManagementAPI.Models;

namespace EventManagementAPI.DTOs
{
    public class CommentListingDto
    {
        public required List<Comment> PinnedComments { get; set; }
        public required List<Comment> Comments { get; set; }
    }
}
