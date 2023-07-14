using EventManagementAPI.Context;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using Microsoft.AspNetCore.JsonPatch;
using Microsoft.EntityFrameworkCore;

namespace EventManagementAPI.Repositories
{
    public class CustomerRepository : ICustomerRepository
    {
        private readonly MySqlContext _dbContext;

        public CustomerRepository(MySqlContext dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task<List<Customer>> GetAllCustomers()
        {
            return await _dbContext.customers.ToListAsync();
        }

        public async Task<Customer?> GetCustomerById(int customerId)
        {
            return await _dbContext.customers.FindAsync(customerId);
        }

        public async Task<Customer> UpdateCustomerByPatch(int id, JsonPatchDocument<Customer> customerDocument)
        {
            var customerById = await _dbContext.customers.FindAsync(id);
            if (customerById == null)
            {
                return customerById;
            }

            customerDocument.ApplyTo(customerById);
            await _dbContext.SaveChangesAsync();

            return customerById;
        }

        public async Task<Customer> UpdateCustomer(Customer customer)
        {
            _dbContext.customers.Update(customer);
            await _dbContext.SaveChangesAsync();

            return customer;
        }

        public async Task<bool> SubscribeHoster(int customerId, int hosterId)
        {
            var customer = await _dbContext.customers.FindAsync(customerId);
            var hoster = await _dbContext.hosts.FindAsync(hosterId);

            if (customer == null || hoster == null)
            {
                return false;
            }

            var subscription = new Subscription();
            subscription.hoster = hoster;
            subscription.hosterIdRef = hosterId;
            subscription.customer = customer;
            subscription.customerIdRef = customerId;

            _dbContext.subscriptions.Add(subscription);
            await _dbContext.SaveChangesAsync();

            return true;
        }

        public async Task<bool> UndoSubscribeHoster(int subscriptionId)
        {
            var subscription = await _dbContext.subscriptions.FindAsync(subscriptionId);

            if (subscription == null)
            {
                return false;
            }

            _dbContext.subscriptions.Remove(subscription);
            await _dbContext.SaveChangesAsync();
            return true;
        }

        public async Task<bool> SaveEvent(int customerId, int eventId)
        {
            var customer = await _dbContext.customers.FindAsync(customerId);
            var e = await _dbContext.events.FindAsync(eventId);

            if (customer == null || e == null)
            {
                return false;
            }

            e.numberSaved++;

            var saveEvent = new EventSaved()
            {
                customerId = customerId,
                eventId = eventId,
                customer = customer,
                eventShow = e,
            };

            _dbContext.Add(saveEvent);
            await _dbContext.SaveChangesAsync();

            return true;
        }

        public async Task<bool> UndoSaveEvent(int saveEventId)
        {
            var saveEvent = await _dbContext.events.FindAsync(saveEventId);

            if (saveEvent == null)
            {
                return false;
            }

            var eventId = saveEvent.eventId;
            var e = await _dbContext.events.FindAsync(eventId);

            if (e != null)
            {
                e.numberSaved--;
            }

            _dbContext.Remove(saveEvent);
            await _dbContext.SaveChangesAsync();

            return true;
        }
    }
}
