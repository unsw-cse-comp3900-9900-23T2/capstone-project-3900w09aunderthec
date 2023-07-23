using EventManagementAPI.Context;
using EventManagementAPI.Models;
using System.Text.RegularExpressions;
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

        /// <summary>
        /// Check email format
        /// </summary>
        /// <param name="email"></param>
        /// <returns>
        /// A boolean value to indicate whether the email address is in a valid format
        /// </returns>
		public bool validateEmailRegex(String email)
		{
            // Email validating Regular Expression
			Regex rx = new Regex(@"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
            MatchCollection matches = rx.Matches(email);

            if (matches.Count != 1) return false;
            return true;
		}
        
        /// <summary>
        /// Check if the email exists in the database
        /// </summary>
        /// <param name="email"></param>
        /// <returns>
        /// A boolean value wether the email address is used before
        /// </returns>
        public async Task<bool> checkDuplicateEmails(String email)
        {
            int count = await _dbContext.customers
                                        .CountAsync(e => e.email == email);
            if (count > 0) return false;
            return true;
        }

        /// <summary>
        /// Create a new user
        /// </summary>
        /// <param name="username"></param>
        /// <param name="email"></param>
        /// <param name="isHost"></param>
        /// <returns>
        /// void
        /// </returns>
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

        /// <summary>
        /// Get initial data
        /// </summary>
        /// <param name="email"></param>
        /// <returns>
        /// An InitialData object
        /// </returns>
        public async Task<InitialData> getInitialData(String email)
        {
            bool emailExistsInHosts = await _dbContext.hosts.AnyAsync(h => h.email == email);

            if (emailExistsInHosts)
            {
                var userEntity = await _dbContext.hosts.FirstOrDefaultAsync(e => e.email == email);

                return new InitialData
                {
                    email = email,
                    isHost = true,
                    uid = userEntity.uid
                };
            } else
            {
                var userEntity = await _dbContext.customers.FirstOrDefaultAsync(e => e.email == email);

                return new InitialData
                {
                    email = email,
                    isHost = false,
                    uid = userEntity.uid,
                    loyaltyPoints = userEntity.loyaltyPoints,
                    vipLevel = userEntity.vipLevel,
                };
            }
        }
    }
}

