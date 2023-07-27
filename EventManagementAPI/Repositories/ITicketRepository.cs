﻿using System.Collections.Generic;
using System.Threading.Tasks;
using EventManagementAPI.Models;
using EventManagementAPI.DTOs;

namespace EventManagementAPI.Repositories
{
    public interface ITicketRepository
    {
        public Task CreateBookingTicket(Ticket t);
        public Task<List<Ticket>> ShowEventTickets(int eventId, int customerId);
        public Task<Ticket> GetTicketById(int ticketId);
        public Task<Ticket> ModifyTicket(TicketModificationDTO mod);
        public Task DeleteTicket(Ticket t);
        public Task<Dictionary<string,int>> GetMyTickets(int eventId, int customerId);
    }
}
