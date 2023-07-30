using System.Net;
using System.Net.Mail;
using System.Net.Mail.Abstractions;

namespace EventManagementAPI.Services
{
    public class EmailService
    {
        private readonly ISmtpClient _smtpClient;
        private readonly string _smtpHost;
        private readonly int _smtpPort;
        private readonly string _smtpUsername;
        private readonly string _smtpPassword;

        public EmailService(ISmtpClient smtpClient, IConfiguration configuration)
        {
            _smtpClient = smtpClient;
            _smtpClient.EnableSsl = true;
            _smtpClient.UseDefaultCredentials = false;
            _smtpHost = configuration["Smtp:Host"];
            _smtpPort = Convert.ToInt32(configuration["Smtp:Port"]);
            _smtpUsername = configuration["Smtp:Username"];
            _smtpPassword = configuration["Smtp:Password"];
        }

        public void SendEmail(string from, string to, string subject, string body)
        {
            using (MailMessage mailMessage = new MailMessage())
            {
                mailMessage.From = new MailAddress(from);
                mailMessage.To.Add(to);
                mailMessage.Subject = subject;
                mailMessage.Body = body;

                _smtpClient.Host = _smtpHost;
                _smtpClient.Port = _smtpPort;
                _smtpClient.EnableSsl = true;
                _smtpClient.UseDefaultCredentials = false;
                _smtpClient.Credentials = new NetworkCredential(_smtpUsername, _smtpPassword);

                _smtpClient.Send(mailMessage);
            }
        }
    }
}
