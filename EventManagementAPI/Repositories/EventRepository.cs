using EventManagementAPI.Context;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using EventManagementAPI.DTOs;
using Microsoft.EntityFrameworkCore;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Net.Http.Headers;
using Microsoft.Extensions.Logging;
using System.Globalization;

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

        public async Task<List<Event>> GetAllEvents(int? uid, string? sortby, string? tags)
        {
            IQueryable<Event> query;

            query = _dbContext.events;
            if (uid is not null)
            {
                if (await _dbContext.hosts.AnyAsync(h => h.uid == uid))
                {
                    query = _dbContext.events.Where(e => e.hosterFK == uid);
                } else if (await _dbContext.customers.AnyAsync(c => c.uid == uid))
                {
                    if (sortby == "recommended") {
                        // Sprint 3 - Change this to sort query by most recommended events
                        query = _dbContext.events;
                    } else {
                        query = _dbContext.bookings
                            .Join(_dbContext.tickets,
                                b => b.ticketId,
                                t => t.ticketId,
                                (b,t) => new
                                {
                                    b.customerId,
                                    t.toEvent
                                })
                            .Where(c => c.customerId == uid)
                            .Select(c => c.toEvent);
                    }
                } else
                {throw new BadHttpRequestException("That user does not exist");}
            }

            switch (sortby)
            {
                case "most_recent":
                    query = query.OrderByDescending(e => e.createdTime);
                    break;
                case "most_saved":
                    query = query.OrderByDescending(e => e.numberSaved);
                    break;
                default:
                    break;
            }

            var events = await query.ToListAsync();

            if(tags is not null)
            {
            events.RemoveAll(e => !(Enumerable.Intersect(e.tags.Split(","),tags.Split(",")).Count() == tags.Split(",").Count()));
            }

            return events;
        }

        public async Task CreateAnEvent(Event e)
        {
            if (!await _dbContext.hosts
                .AnyAsync(h => h.uid == e.hosterFK)) {
                throw new BadHttpRequestException("That host does not exist");
            }
                
            _dbContext.events.Add(e);
            await _dbContext.SaveChangesAsync();
        }

        public async Task<Event> GetEventById(int id)
        {
            var e = await _dbContext.events
                .FirstOrDefaultAsync(e => e.eventId == id);
            return e;
        }

        public async Task ModifyEvent(EventModificationDto mod)
        {

            if(!_dbContext.events.Any(e => e.eventId == mod.eventId))
            {
                throw new BadHttpRequestException("That event does not exist");
            }

            Event e = await _dbContext.events.FirstAsync(e => e.eventId == mod.eventId);

            if(mod.title is not null){e.title = mod.title;}
            if(mod.venue is not null){e.venue = mod.venue;}
            if(mod.description is not null){e.description = mod.description;}
            if(mod.allowRefunds is not null){e.allowRefunds = mod.allowRefunds ?? default(bool);}
            if(mod.privateEvent is not null){e.privateEvent = mod.privateEvent ?? default(bool);}
            if(mod.tags is not null){e.tags = mod.tags;}

            _dbContext.events.Update(e);
            await _dbContext.SaveChangesAsync();
        }

        public async Task<Event?> CancelEvent(int eventId)
        {
            var e = await _dbContext.events.FindAsync(eventId);

            if (e != null)
            {
                _dbContext.Remove(e);
                await _dbContext.SaveChangesAsync();
            }

            return e;
        }
    }
}
