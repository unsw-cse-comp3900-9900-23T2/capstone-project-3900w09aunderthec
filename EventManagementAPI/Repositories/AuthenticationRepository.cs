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
            // Console.WriteLine("createUser called");
            // Console.WriteLine(username);
            // Console.WriteLine(email);
            // Console.WriteLine(isHost);
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
            _dbContext.SaveChanges();
        }

        public async Task<InitialData> getInitialData(String email)
        {
            // Console.WriteLine("getInitialData called");
            // Console.WriteLine(email);
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

