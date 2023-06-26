class Address {
  final String venue;
  final String suburb;
  final String city;
  final String country;
  final String postalCode;
  final bool? online;

  Address(
      {required this.venue,
      required this.suburb,
      required this.city,
      required this.country,
      required this.postalCode,
      bool? online}) : online = false;
}
