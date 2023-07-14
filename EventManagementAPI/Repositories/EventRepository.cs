using EventManagementAPI.Context;
using EventManagementAPI.Models;
using EventManagementAPI.Repositories;
using Microsoft.EntityFrameworkCore;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Net.Http.Headers;

static class Constants
{
    public const string tagList = "music, art, food, drinks, wine, beer, cocktails, dance, theater, comedy, laughter, film, gala, sports, fitness, clothes, yoga, meditation, conference, workshop, seminar, festival, concert, exhibition, gallery, photography, books, literature, poetry, writing, cooking, culinary, dining, outdoors, adventure, hiking, nature, environment, charity, fundraising, volunteering, community, family, children, parenting, education, science, history, culture, heritage, travel, tourism, beach, nightlife, clubbing, party, DJ, karaoke, open mic, live, performance, competition, contest, esports, gaming, style, beauty, health, wellness, nutrition, self-improvement, motivation, entrepreneurship, business, career, finance, investment, leadership, management, marketing, sales, innovation, technology, coding, programming, web, software, hardware, design, art, creativity, painting, sculpture, digital, fashion, textiles, handmade, jewelry, accessories, vintage, retro, collectibles, antiques, home, decor, gardening, DIY, crafts, knitting, crochet, quilting, sewing, runway, models, auction, haute couture, gourmet, woodworking, architecture, engineering, immersive, finals, athletes, stadium, robotics, AI, machine learning, data science, virtual reality, augmented reality, artists, blockchain, cryptocurrency, renewable energy, sustainability, green, climate change, social, justice, diversity, equality, inclusion, LGBTQ+, feminism, mental health, mindfulness, personal, development, relationships, dating, love, friendship, networking, socializing, singles, couples, professionals, students, artists, musicians, creatives, entrepreneurs, startups, tech enthusiasts, families, parents, seniors, youth, kids, book lovers, history buffs, sports fans, foodies, wine lovers, beer enthusiasts, coffee, addicts, early birds, night owls, morning, afternoon, evening, night, spa, international";
    public static readonly List<string> listTagList = new List<string> {"music", "art", "food", "drinks", "wine", "beer", "cocktails", "dance", "theater", "comedy", "laughter", "film", "gala", "sports", "fitness", "clothes", "yoga", "meditation", "conference", "workshop", "seminar", "festival", "concert", "exhibition", "gallery", "photography", "books", "literature", "poetry", "writing", "cooking", "culinary", "dining", "outdoors", "adventure", "hiking", "nature", "environment", "charity", "fundraising", "volunteering", "community", "family", "children", "parenting", "education", "science", "history", "culture", "heritage", "travel", "tourism", "beach", "nightlife", "clubbing", "party", "DJ", "karaoke", "open mic", "live", "performance", "competition", "contest", "esports", "gaming", "style", "beauty", "health", "wellness", "nutrition", "self-improvement", "motivation", "entrepreneurship", "business", "career", "finance", "investment", "leadership", "management", "marketing", "sales", "innovation", "technology", "coding", "programming", "web", "software", "hardware", "design", "art", "creativity", "painting", "sculpture", "digital", "fashion", "textiles", "handmade", "jewelry", "accessories", "vintage", "retro", "collectibles", "antiques", "home", "decor", "gardening", "DIY", "crafts", "knitting", "crochet", "quilting", "sewing", "runway", "models", "auction", "haute couture", "gourmet", "woodworking", "architecture", "engineering", "immersive", "finals", "athletes", "stadium", "robotics", "AI", "machine learning", "data science", "virtual reality", "augmented reality", "artists", "blockchain", "cryptocurrency", "renewable energy", "sustainability", "green", "climate change", "social", "justice", "diversity", "equality", "inclusion", "LGBTQ+", "feminism", "mental health", "mindfulness", "personal", "development", "relationships", "dating", "love", "friendship", "networking", "socializing", "singles", "couples", "professionals", "students", "artists", "musicians", "creatives", "entrepreneurs", "startups", "tech enthusiasts", "families", "parents", "seniors", "youth", "kids", "book lovers", "history buffs", "sports fans", "foodies", "wine lovers", "beer enthusiasts", "coffee", "addicts", "early birds", "night owls", "morning", "afternoon", "evening", "night", "spa", "international"};
    public const string instruction = "You are a classification machine. You receive information about an event to be listed on a popular event advertisement and ticketing website. Following this, you receive a comma separated list of short descriptors, referred to as 'tags'. You should respond with a comma separated list of hopefully at least six tags coming from the provided list that are relevant, even very weakly, to the event. Your response must contain only tags that appear in the provided list. It must NOT create new tags under ANY circumstances, even if the word appears in the event description! To repeat, the reponse must ONLY contain tags from the provided list. The response should be a comma separated list of tags, formatted identically to the provided list, and nothing else. Try to include as many tags as possible.";
}
public class JsonMessage
{
    public string model { get; set; } = "gpt-3.5-turbo";
    public List<Dictionary<string, string>> messages { get; set; }
    public int n { get; set;} = 3; // Number of responses to generate

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
                {"content", descriptorString + "\n\n" + Constants.tagList}
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

            returnList.RemoveAll(t => !Constants.listTagList.Contains(t));

            return returnList;
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
