using EventManagementAPI.Context;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using Microsoft.EntityFrameworkCore;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Net.Http.Headers;

public class JsonMessage
{
    public string model { get; set; } = "gpt-3.5-turbo";
    public List<Dictionary<string, string>> messages { get; set; }

    public JsonMessage()
    {
        messages = new List<Dictionary<string, string>>
        {
            new Dictionary<string, string>
            {
                {"role", "system"},
                {"content", "You are a helpful assistant"}
            },
            new Dictionary<string, string>
            {
                {"role", "user"},
                {"content", "Hello!"}
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

            JsonMessage sendMe = new JsonMessage();

            var options = new JsonSerializerOptions
            {
                PropertyNamingPolicy = JsonNamingPolicy.CamelCase
            };

            
            HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Post, "https://api.openai.com/v1/chat/completions");

            request.Content = new StringContent(JsonSerializer.Serialize(sendMe, options),
                                        Encoding.UTF8, 
                                        "application/json");

            var response = await client.SendAsync(request);

            var responseString = await response.Content.ReadAsStringAsync();

            var jsonCrap = JsonSerializer.Deserialize<APIResponse>(responseString);

            Console.WriteLine(responseString);
            Console.WriteLine(jsonCrap.choices);
            Console.WriteLine(jsonCrap.choices.Last().message.content);

            return new List<string>();
        }

        public async Task<List<Event>> GetAllEvents()
        {
            return await _dbContext.events.ToListAsync();
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

        public async Task ModifyEvent(Event e)
        {
            _dbContext.events.Update(e);
            await _dbContext.SaveChangesAsync();
        }

        public async Task<List<Event>> GetAllHostEvents(int hostId)
        {
            var events = await _dbContext.events
                .Where(e => e.hosterFK == hostId || e.privateEvent == false)
                .ToListAsync();

            return events;
        }
    }
}
