class APIRoutes {
  APIRoutes._(); //Prevent this class to be instantalized

  static const String BASE_URL = '10.0.2.2:7161';
  static const headers = {
    "Access-Control-Allow-Origin": "*",
    'Content-Type': 'application/json',
    'Accept': '*/*'
  };

  // auth
  static const String register = '/Authentification/RegisterUser';
  static const String getUserType = '/Authentification/GetUserType';

  // events get
  static const String getEvents = '/EventDisplay/ListEvents';
  static const String getHostEvents = '/EventDisplay/ListHostEvents';
  static const String getEventDetails = '/EventDisplay/showEventDetails';
  static const String getMyEvents = '/EventDisplay/ListMyEvents';

  // events creation
  static const String createEvent = '/EventCreation/CreateEvent';

  // ticket
  static const String getTicket = '/Ticket/ShowTicketDetails';
  static const String getTickets = '/Ticket/ShowTickets';
}
