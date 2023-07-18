class APIRoutes {
  APIRoutes._(); //Prevent this class to be instantalized

  static const String BASE_URL = '10.0.2.2:7161';
  static const headers = {
    "Access-Control-Allow-Origin": "*",
    'Content-Type': 'application/json',
    'Accept': '*/*'
  };

  // =============================AUTH ROUTES===================================
  static const String register = '/Authentification/RegisterUser';
  static const String getUserType = '/Authentification/GetUserType';

  // ============================EVENT ROUTES===================================
  // static const String getHostEvents = '/EventDisplay/ListHostEvents';
  static const String getEvents = '/EventDisplay/ListEvents';
  static const String getEventDetails = '/EventDisplay/showEventDetails';
  static const String getCustomerEvents = '/EventDisplay/ListMyEvents';

  static const String createEvent = '/EventCreation/CreateEvent';
  static const String getTags = '/EventCreation/GetTags';
  static const String modifyEvent = '/EventCreation/ModifyEvent';
  static const String cancelEvent = '/EventCreation/CancelEvent';

  // ============================TICKET ROUTES==================================
  static const String getTicket = '/Ticket/ShowTicketDetails';
  static const String getTickets = '/Ticket/ShowTickets';
  static const String createTickets = '/Ticket/CreateTickets';
  static const String deleteTickets = '/Ticket/DeleteTickets';
  static const String bookTickets = 'api/Booking/MakeBooking';
  static String getBooking(String uid) => 'api/Booking/GetBookings/$uid';
}
