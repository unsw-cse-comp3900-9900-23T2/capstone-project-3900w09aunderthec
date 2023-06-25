using EventManagementAPI.Context;
using EventManagementAPI.Models;
using System.Text.RegularExpressions;
using EventManagementAPI.Repositories;
using Microsoft.EntityFrameworkCore;

namespace EventManagementAPI.Repositories
{
	public class AuthenticationRepository : IAuthenticationRepository
	{
        private readonly MySqlContext _dbContext;

        public AuthenticationRepository(MySqlContext dbContext)
        {
            _dbContext = dbContext;
        }

		public bool validateEmailRegex(String email)
		{
            // Email validating Regular Expression
			Regex rx = new Regex(@"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
            MatchCollection matches = rx.Matches(email);

            if (matches.Count != 1) return false;
            return true;
		}
        
        public async Task<bool> checkDuplicateEmails(String email)
        {
            int count = await _dbContext.customers
                                        .CountAsync(e => e.email == email);
            if (count > 0) return false;
            return true;
        }

        public async Task createUser(String username, String email, Boolean isHost)
        {
            if (isHost) {
                _dbContext.hosts.Add(
                new Hoster{
                    username = username,
                    email = email,
                    organisationName = username
                });
            } else {
                _dbContext.customers.Add(
                new Customer{
                    username = username,
                    email = email,
                });
            }
            await _dbContext.SaveChangesAsync();
        }
	}
}

