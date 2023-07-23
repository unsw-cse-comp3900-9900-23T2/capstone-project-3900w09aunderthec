﻿using EventManagementAPI.Context;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using Microsoft.EntityFrameworkCore;

namespace EventManagementAPI.Repositories
{
    public class EventHostRepository : IEventHostRepository
    {
        private readonly MySqlContext _dbContext;

        public EventHostRepository(MySqlContext dbContext)
        {
            _dbContext = dbContext;
        }

        /// <summary>
        /// Get all event hosters
        /// </summary>
        /// <returns>
        /// A list of Hoster objects
        /// </returns>
        public async Task<List<Hoster>> GetAllEventHosts()
        {
            return await _dbContext.hosts.ToListAsync();
        }
    }
}
