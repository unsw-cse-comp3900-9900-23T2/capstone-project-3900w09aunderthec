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
  static const String emailNotification = '/EventCreation/EmailNotification';

  // ============================TICKET ROUTES==================================
  static const String getTicket = '/Ticket/ShowTicketDetails';
  static const String getTickets = '/Ticket/ShowTickets';
  static const String createTickets = '/Ticket/CreateTickets';
  static const String deleteTickets = '/Ticket/DeleteTickets';
  static const String bookTickets = 'api/Booking/MakeBooking';

  // ============================COMMENT ROUTES=================================
  static const String getComments = 'api/Comment/ListComments';
  static const String getCommentById = 'api/Comment/GetComment';
  static const String createComment = 'api/Comment/PostComment';
  static const String likeComment = 'api/Comment/ToggleLikeComment';
  static const String dislikeComment = 'api/Comment/ToggleDislikeComment';
  static const String getCustomerById = 'api/Customer';
  static const String isLikeComment = 'api/Comment/isLikeComment';
  static const String isDislikeComment = 'api/Comment/isDislikeComment';
  static const String pinComment = 'api/Comment/PinComment';

  // ===========================CUSTOMER ROUTES=================================
  static const String subscribe = 'api/Customer/Subscribe';

  // ============================BOOKING ROUTES==================================
  static String getBooking(String uid) => 'api/Booking/GetBookings/$uid';
  static String getBookingDetail(String bookingId) =>
      'api/Booking/GetBookingDetails/$bookingId';
  static const String cancelBooking = 'api/Booking/CancelBooking';

  // ===========================Analytics ROUTES=================================
  static const String getEventsYearlyDistribution = 'api/Hoster/GetEventsyearlyDistribution';
  static const String getNumberEventsHosted = 'api/Hoster/GetNumberOfEventsHosted';
  static const String getNumberTicketsSold = 'api/Hoster/GetTicketsSold';
  static const String getNumberSubscribers = 'api/Hoster/GetSubscribers';
  static const String getPercentageBeaten = 'api/Hoster/GetPercentageBeaten';
}
