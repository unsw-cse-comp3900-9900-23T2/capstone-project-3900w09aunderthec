// class to store all app routes (not api routes)
class AppRoutes {
  AppRoutes._(); //Prevent this class to be instantalized

  // for auth
  static const String register = '/register';
  static const String reset = '/reset';

  /* for shared */
  // events
  static const String events = '/event';
  static const String home = '/home';
  static const String profile = '/profile';
  static String eventDetails(String id) => '/event/event_details/$id';
  static String eventBook(String id, String title, String venue) =>
      '/event/book/$id/$title/$venue';
  static const String eventAdd = '/event/add';
  static String eventModify(String id) => '/event/modify/$id';

  /* for non shared*/
  // for host
  static const String host = '/host';
  static const String hostAnalytics = '/host/analytics';
  static const String hostProfile = '/host/profile';
  static String notification(String eventId) => '/event/notification/$eventId';

  // for customer
  static const String customer = '/customer';
  static const String customerProfile = '/customer/profile';
  static String viewBooking(String id) => '/customer/profile/view_booking/$id';

  // for guest
  static const String guest = '/guest';
  static const String guestProfile = '/guest/profile';

  // analytics
  static const String analytics = '/analytics';

  // tickets
  static String ticketConfirmation(String eventName) =>
      '/ticket/confirmation/$eventName';
  static String ticketCreate(String id) => '/ticket/create/$id';
}
