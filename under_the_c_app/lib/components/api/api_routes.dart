class APIRoutes {
  APIRoutes._(); //Prevent this class to be instantalized

  // auth
  static const String register = '/Authentification/RegisterUser';
  static const String getUserType = '/Authentification/GetUserType';

  // events
  static const String getEvents = '/EventDisplay/ListEvents';
  static const String getHostEvents = '/EventDisplay/ListHostEvents';
  static const String getEventDetails = '/EventDisplay/showEventDetails';
  static const String getMyEvents = '/EventDisplay/ListMyEvents';
}
