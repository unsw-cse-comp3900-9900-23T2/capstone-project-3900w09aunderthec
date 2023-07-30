using EventManagementAPI.Context;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using Microsoft.AspNetCore.JsonPatch;
using Microsoft.EntityFrameworkCore;
using System.Reflection.Metadata.Ecma335;

namespace EventManagementAPI.Repositories
{
    public class CustomerRepository : ICustomerRepository
    {
        private readonly MySqlContext _dbContext;

        public CustomerRepository(MySqlContext dbContext)
        {
            _dbContext = dbContext;
        }

        /// <summary>
        /// Retrieve a list of customers
        /// </summary>
        /// <returns>
        /// A list of Customer objects
        /// </returns>
        public async Task<List<Customer>> GetAllCustomers()
        {
            return await _dbContext.Customers.ToListAsync();
        }

        /// <summary>
        /// Get details of a customer
        /// </summary>
        /// <param name="customerId"></param>
        /// <returns>
        /// A Customer object
        /// </returns>
        public async Task<Customer?> GetCustomerById(int customerId)
        {
            return await _dbContext.Customers.FindAsync(customerId);
        }

        /// <summary>
        /// Update Customer object
        /// </summary>
        /// <param name="id"></param>
        /// <param name="customerDocument"></param>
        /// <returns>
        /// Updated Customer object
        /// </returns>
        public async Task<Customer> UpdateCustomerByPatch(int id, JsonPatchDocument<Customer> customerDocument)
        {
            var customerById = await _dbContext.Customers.FindAsync(id) ?? throw new KeyNotFoundException("customer to be updated not found");
            customerDocument.ApplyTo(customerById);
            await _dbContext.SaveChangesAsync();

            return customerById;
        }

        /// <summary>
        /// Update a customer
        /// </summary>
        /// <param name="customer"></param>
        /// <returns>
        /// Updated Customer object
        /// </returns>
        public async Task<Customer> UpdateCustomer(Customer customer)
        {
            _dbContext.Customers.Update(customer);
            await _dbContext.SaveChangesAsync();

            return customer;
        }

        /// <summary>
        /// Subscribe or Unsubscribe a hoster
        /// </summary>
        /// <param name="customerId"></param>
        /// <param name="hosterId"></param>
        /// <returns>
        /// A subscription object that either newly created or deleted
        /// </returns>
        /// <exception cref="KeyNotFoundException"></exception>
        public async Task<Subscription> SubscribeHoster(int customerId, int hosterId)
        {
            var customer = await _dbContext.Customers.FindAsync(customerId) ?? throw new KeyNotFoundException("customer not found");
            var hoster = await _dbContext.Hosts.FindAsync(hosterId) ?? throw new KeyNotFoundException("hoster not found");

            var subscription = await _dbContext.Subscriptions.FirstOrDefaultAsync(s => s.customerIdRef == customerId && s.hosterIdRef == hosterId);

            if (subscription == null)
            {
                var newSubscription = new Subscription
                {
                    hoster = hoster,
                    hosterIdRef = hosterId,
                    customer = customer,
                    customerIdRef = customerId,
                };
                _dbContext.Subscriptions.Add(newSubscription);
                await _dbContext.SaveChangesAsync();
                return newSubscription;
            } else
            {
                _dbContext.Subscriptions.Remove(subscription);
            }
            
            await _dbContext.SaveChangesAsync();
            return subscription;
        }

        /// <summary>
        /// Save or Unsave an event
        /// </summary>
        /// <param name="customerId"></param>
        /// <param name="eventId"></param>
        /// <returns>
        /// An EventSaved object that either newly created or deleted
        /// </returns>
        /// <exception cref="KeyNotFoundException"></exception>
        public async Task<EventSaved> SaveEvent(int customerId, int eventId)
        {
            var customer = await _dbContext.Customers.FindAsync(customerId) ?? throw new KeyNotFoundException("customer not found");
            var e = await _dbContext.Events.FindAsync(eventId) ?? throw new KeyNotFoundException("event not found");

            var eventSaved = await _dbContext.EventsSaved.FirstOrDefaultAsync(es => es.customerId == customerId && es.eventId == eventId);

            if (eventSaved == null)
            {
                var newEventSaved = new EventSaved
                {
                    customerId = customerId,
                    customer = customer,
                    eventId = eventId,
                    eventShow = e,
                };
                e.numberSaved++;
                _dbContext.Add(newEventSaved);
                await _dbContext.SaveChangesAsync();
                return newEventSaved;
            }

            e.numberSaved--;
            _dbContext.Remove(eventSaved);
            await _dbContext.SaveChangesAsync();
            return eventSaved;
        }
    }
}
