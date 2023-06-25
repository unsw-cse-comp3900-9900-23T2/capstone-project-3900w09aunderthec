﻿using System;
using EventManagementAPI.Context;
using EventManagementAPI.Models;
using System.Text.RegularExpressions;
using Microsoft.EntityFrameworkCore;

namespace EventManagementAPI.Repositories
{
	public class AuthenticationRepository : IAuthenticationRepository
	{
        readonly MySqlContext _dbContext;

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

        public async void createUser(String username, String email, Boolean isHost)
        {
            if (isHost) {
                _dbContext.Add(
                new Hoster{
                    username = username,
                    email = email,
                    organisationName = username
                });
            } else {
                _dbContext.Add(
                new Customer{
                    username = username,
                    email = email,
                });
            }
        }
	}
}

