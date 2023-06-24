// using System;
// using System.ComponentModel.DataAnnotations.Schema;
// using System.ComponentModel.DataAnnotations;

// namespace EventManagementAPI.Models
// {
//     public class Address
//     {
//         [Key]
//         [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
//         public int Id { get; set; }
//         public string State { get; set; }
//         public string City { get; set; }
//         public string Postcode { get; set; }
//         public string Suburb { get; set; }
//         public string Street { get; set; }
//         public int? UserId { get; set; }
//         public User User { get; set; }
//         public int? EventId { get; set; }
//         public Event Event { get; set; }
//     }
// }
