class AppRoutes {
  AppRoutes._(); //Prevent this class to be instantalized

  // for auth
  static const String register = '/register';
  static const String reset = '/reset';

  /* for shared */
  // events
  static const String events = '/event';
  static String eventDetails(String id) => '/event/event_detail/$id';
  static String eventBook(String id) => '/event/book/$id';
  static const String eventAdd = '/event/add';

  /* for non shared*/
  // for host
  static const String host = '/host';
  static const String hostAnalytics = '/host/analytics';
  static const String hostProfile = '/host/profile';

  // for customer
  static const String customer = '/customer';
  static const String customerProfile = '/customer/profile';

  // for guest
  static const String guest = '/guest';
  static const String guestProfile = '/guest/profile';
}
