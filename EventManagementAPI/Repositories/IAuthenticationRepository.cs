using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using EventManagementAPI.Models;

namespace EventManagementAPI.Repositories
{
    public interface IAuthenticationRepository
	{
        bool validateEmailRegex(String email);
        Task<bool> checkDuplicateEmails(String email);
        Task createUser(String username, String email, Boolean isHost);
        Task<InitialData> getInitialData(String email);
    }
}

