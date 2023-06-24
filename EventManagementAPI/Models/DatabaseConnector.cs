// Old Database connection method. Disregard.
//
//using System;
// using Microsoft.AspNetCore.Mvc;
// using Client = MySql.Data.MySqlClient;

// namespace EventManagementAPI.Models
// {
//     public class DatabaseConnector
//     {

//         Client.MySqlConnection conn = new Client.MySqlConnection();

//         private void openConnection() {
//             if (conn.State == System.Data.ConnectionState.Open) return;
//             conn.Close();
//             conn.ConnectionString = "server=localhost;uid=root;" +
//             "pwd=mysql123456;database=underthec";
//             conn.Open();
//         }

//         public Client.MySqlCommand? getSqlCommand () {
//             /*  Helper function to allow easy access to the database.
//                 Set the command's CommandText variable to the Query you
//                 want to execute, and then call the .ExecuteReader() method
//                 to receive a SQL reader.
             
//                 Output:
//                  - SQL command

//                 Don't forget to close the command and reader with the .Close() method!
//             */

//             try
//             {
//                 openConnection();

//                 Client.MySqlTransaction trans = conn.BeginTransaction();
//                 Client.MySqlCommand command = conn.CreateCommand();

//                 return command;
//             }
//             catch (Client.MySqlException ex)
//             {
//                 Console.WriteLine(ex.Message);
//                 return null;
//             }
//         }
//     }
// }