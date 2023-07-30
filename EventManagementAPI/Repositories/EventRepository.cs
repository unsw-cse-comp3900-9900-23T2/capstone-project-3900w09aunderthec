using EventManagementAPI.Context;
using EventManagementAPI.Models;
using EventManagementAPI.DTOs;
using EventManagementAPI.Repositories;
using Microsoft.EntityFrameworkCore;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Net.Http.Headers;
using Microsoft.Extensions.Logging;
using System.Globalization;
using System;
using System.Diagnostics;
using System.Text.RegularExpressions;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore.ChangeTracking.Internal;

public class JsonMessage
{
    public string model { get; set; } = "gpt-3.5-turbo";
    public List<Dictionary<string, string>> messages { get; set; }
    public int n { get; set;} = 5; // Number of responses to generate

    public JsonMessage(string descriptorString)
    {
        messages = new List<Dictionary<string, string>>
        {
            new Dictionary<string, string>
            {
                {"role", "system"},
                {"content", Constants.instruction}
            },
            new Dictionary<string, string>
            {
                {"role", "user"},
                {"content", descriptorString + "\n\n" + string.Join(", ", Constants.tagList)}
            }
        };
    }
}

public class Message
{
    public string role { get; set; }
    public string content { get; set; }
}

public class Choice
{
    public int index { get; set; }
    public Message message { get; set; }
    public string finish_reason { get; set; }
}

public class Usage
{
    public int prompt_tokens { get; set; }
    public int completion_tokens { get; set; }
    public int total_tokens { get; set; }
}

public class APIResponse
{
    public string id { get; set; }
    [JsonPropertyName("object")]
    public string Object { get; set; }
    public long created { get; set; }
    public string model { get; set; }
    public List<Choice> choices { get; set; }
    public Usage usage { get; set; }
}

namespace EventManagementAPI.Repositories
{
    public class EventRepository : IEventRepository
    {
        
        private readonly IHttpClientFactory _httpClientFactory;
        private readonly MySqlContext _dbContext;

        public EventRepository(MySqlContext dbContext, IHttpClientFactory httpClientFactory)
        {
            _dbContext = dbContext;
            _httpClientFactory = httpClientFactory;
        }

        /// <summary>
        /// Get tags
        /// </summary>
        /// <param name="descriptorString"></param>
        /// <returns>
        /// A list of tag string
        /// </returns>
        public async Task<List<string>> GetTags(string descriptorString)
        {
            var client = _httpClientFactory.CreateClient();
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
            client.DefaultRequestHeaders.Add("Authorization", "Bearer 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");

            JsonMessage sendMe = new JsonMessage(descriptorString);

            var options = new JsonSerializerOptions
            {
                PropertyNamingPolicy = JsonNamingPolicy.CamelCase
            };
            
            HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Post, "https://api.openai.com/v1/chat/completions");

            request.Content = new StringContent(JsonSerializer.Serialize(sendMe, options),
                                        Encoding.UTF8, 
                                        "application/json");

            string sentString = await request.Content.ReadAsStringAsync();

            var response = await client.SendAsync(request);
            var responseString = await response.Content.ReadAsStringAsync();
            var jsonResponse = JsonSerializer.Deserialize<APIResponse>(responseString);

            List<string> returnList = new List<string>();

            foreach (Choice choice in jsonResponse.choices)
            {
                returnList = Enumerable.Union<string>(returnList, choice.message.content.Split(", ")).ToList();
            }

            returnList.RemoveAll(t => !Constants.tagList.Contains(t));

            return returnList;
        }

        /// <summary>
        /// Get a list of events based on various criteria
        /// </summary>
        /// <param name="uid"></param>
        /// <param name="sortby"></param>
        /// <param name="tags"></param>
        /// <param name="showPreviousEvents"></param>
        /// <param name="eventId"></param>
        /// <returns>
        /// A list of EventListingDTO
        /// </returns>
        /// <exception cref="KeyNotFoundException"></exception>
        public async Task<List<EventListingDTO>> GetAllEvents(int? uid, string? sortby, string? tags, bool showPreviousEvents, int? eventId)
        {
            IQueryable<Event> query;
            
            if (eventId.HasValue)
            {
                if (!await _dbContext.Events.AnyAsync(e => e.eventId == eventId))
                {throw new KeyNotFoundException("eventId does not relate to an existing event");}

                query = _dbContext.Events.Where(e => e.eventId != eventId)
                    .OrderByDescending(
                        e => _dbContext.Similarities                        
                            .Where(s => s.fromEventId == e.eventId && s.toEventId == eventId)
                            .Select(s => s.value)
                    );
            }

            if (uid.HasValue)
            {
                if (await _dbContext.Hosts.AnyAsync(h => h.uid == uid))
                {
                    // if uid refers to a hoster
                    // get all hoster events
                    // can't see other events
                    // optional to show past events
                    query = _dbContext.Events.Include(e => e.tickets);
                    query = query.Where(e => e.hosterFK == uid);
                }
                else if (await _dbContext.Customers.AnyAsync(c => c.uid == uid))
                {
                    // if uid refers to a customer
                    // get all events that the customer has made bookings to
                    // they can be public or private
                    // optional to show past events
                    query = _dbContext.BookingTickets
                        .Where(bt => bt.booking.customerId == uid)
                        .Join(_dbContext.Tickets,
                            bt => bt.ticketId,
                            t => t.ticketId,
                            (bt, t) => t.toEvent);
                }
                else
                {
                    throw new KeyNotFoundException("uid does not relate to an existing user");
                }
            } else
            {
                // if uid is not given
                // show all public upcoming events
                query = _dbContext.Events.Where(e => !e.isPrivateEvent);
            }

            if (!showPreviousEvents)
            {
                query = query.Where(e => e.eventTime > DateTime.Now);
            }

            if (sortby is not null)
            {
                switch (sortby)
                {
                    case "soonest":
                        query = query.OrderBy(e => e.eventTime);
                        break;
                    case "most_saved":
                        query = query.OrderByDescending(e => e.numberSaved);
                        break;
                    case "price_high_to_low":
                        query = query.OrderByDescending(e => e.tickets.Where(t => t.eventIdRef == e.eventId).Min(t => t.price));
                        break;
                    case "price_low_to_high":
                        query = query.OrderBy(e => e.tickets.Where(t => t.eventIdRef == e.eventId).Min(t => t.price));
                        break;
                    case "recommended":
                        if (!await _dbContext.Customers.AnyAsync(c => c.uid == uid)) break;

                        query = query.OrderByDescending(e => e.rating.GetValueOrDefault() // Prioritise highly-rated events
                            + _dbContext.BookingTickets // Prioritise events with higher similarity to the customer's prior events 
                            .Where(bt => bt.booking.customerId == uid) 
                            .Join(_dbContext.Tickets,
                                bt => bt.ticketId,
                                t => t.ticketId,
                                (bt, t) => t.eventIdRef)
                            .Join(_dbContext.Similarities.Where(s => s.toEventId == e.eventId),
                                i => i,
                                s => s.fromEventId,
                                (i, s) => s.value
                            )
                            .Average()
                        );
                        break;
                    case "similarity":

                        if (!eventId.HasValue) {throw new KeyNotFoundException("eventId not provided for similarity sorting");}
                        if (!await _dbContext.Events.AnyAsync(e => e.eventId == eventId))
                        {throw new KeyNotFoundException("eventId does not relate to an existing event");}

                        query = query.Where(e => e.eventId != eventId);

                        query = query.OrderByDescending(
                            e => _dbContext.Similarities                        
                                .Where(s => s.fromEventId == e.eventId && s.toEventId == eventId)
                                .Select(s => s.value)
                        );
                            
                        break;
                    default:
                        break;
                }
            }

            var events = await query.ToListAsync();

            if (tags is not null)
            {
                events.RemoveAll(e => !(Enumerable.Intersect(e.tags.Split(","),tags.Split(",")).Count() == tags.Split(",").Count()));
            }

            var eventList = new List<EventListingDTO>();

            foreach (var e in events)
            {
                var eventShow = await _dbContext.Events.Include(e => e.tickets).FirstOrDefaultAsync(ev => ev.eventId == e.eventId) ?? throw new KeyNotFoundException("event not found");
                double cheapestPrice = 0.0;
                if (eventShow.tickets.Count != 0) {
                    cheapestPrice = eventShow.tickets.Min(t => t.price);
                }

                var eventDto = new EventListingDTO
                {
                    eventId = e.eventId,
                    hosterId = e.hosterFK,
                    title = e.title,
                    description = e.description,
                    venue = e.venue,
                    eventTime = e.eventTime,
                    isDirectRefunds = e.isDirectRefunds,
                    isPrivateEvent = e.isPrivateEvent,
                    tags = e.tags,
                    numberSaved = e.numberSaved,
                    cheapestPrice = cheapestPrice,
                };

                eventList.Add(eventDto);
            }

            return eventList;
        }

        /// <summary>
        /// Create a new event
        /// </summary>
        /// <param name="e"></param>
        /// <returns></returns>
        /// <exception cref="KeyNotFoundException"></exception>
        public async Task CreateAnEvent(Event e)
        {
            if (!await _dbContext.Hosts
                .AnyAsync(h => h.uid == e.hosterFK)) {
                throw new KeyNotFoundException("That host does not exist");
            }

            // Saving the event automatically populates the eventId for later use
            _dbContext.Events.Add(e);
            await _dbContext.SaveChangesAsync();
            
            String eventString = Regex.Replace(e.title + ' '
                                             + e.description + ' '
                                             + e.venue,"\n"," ");

            foreach (Event otherEvent in await _dbContext.Events
                .Where(ev => ev.eventId != e.eventId)
                .ToListAsync())
            {
                Double sim = await PythonInterop.EvaluateSimilarity(
                    eventString,
                    Regex.Replace(otherEvent.title + ' '
                                + otherEvent.description + ' '
                                + otherEvent.venue,"\n"," ")
                );
                _dbContext.Similarities.Add(new Similarity{
                    fromEventId = e.eventId,
                    toEventId = otherEvent.eventId,
                    value = sim
                });
                _dbContext.Similarities.Add(new Similarity{
                    fromEventId = otherEvent.eventId,
                    toEventId = e.eventId,
                    value = sim
                });
            }

            await _dbContext.SaveChangesAsync();
        }

        /// <summary>
        /// Get event details
        /// </summary>
        /// <param name="id"></param>
        /// <returns>
        /// An Event object with details
        /// </returns>
        /// <exception cref="KeyNotFoundException"></exception>
        public async Task<Event> GetEventById(int id)
        {
            var e = await _dbContext.Events.FirstOrDefaultAsync(e => e.eventId == id) ?? throw new KeyNotFoundException("event does not exist");
            return e;
        }

        /// <summary>
        /// Update an event
        /// </summary>
        /// <param name="mod"></param>
        /// <returns>
        /// A modified Event object
        /// </returns>
        public async Task<Event> ModifyEvent(EventModificationDTO mod)
        {
            Event e = await _dbContext.Events.FirstAsync(e => e.eventId == mod.eventId);

            if(mod.title is not null){e.title = mod.title;}
            if(mod.eventTime is not null){e.eventTime = mod.eventTime ?? default(DateTime);}
            if(mod.createdTime is not null){e.createdTime = mod.createdTime ?? default(DateTime);}
            if(mod.venue is not null){e.venue = mod.venue;}
            if(mod.description is not null){e.description = mod.description;}
            if(mod.isDirectRefunds is not null){e.isDirectRefunds = mod.isDirectRefunds ?? default(bool);}
            if(mod.isPrivateEvent is not null){e.isPrivateEvent = mod.isPrivateEvent ?? default(bool);}
            if(mod.tags is not null){e.tags = mod.tags;}

            _dbContext.Events.Update(e);
            await _dbContext.SaveChangesAsync();
            return e;
        }

        /// <summary>
        /// Delete an event
        /// </summary>
        /// <param name="eventId"></param>
        /// <returns>
        /// An event object to be deleted
        /// </returns>
        /// <exception cref="KeyNotFoundException"></exception>
        public async Task<Event> CancelEvent(int eventId)
        {
            var e = await _dbContext.Events.FindAsync(eventId) ?? throw new KeyNotFoundException("event to delete does not exist");

            if (e != null)
            {
                _dbContext.Remove(e);
                await _dbContext.SaveChangesAsync();
            }

            return e;
        }
    }
}
