import 'package:under_the_c_app/types/subscription_type.dart';

class Customer {
  final int customerId;
  final String userName;
  final List<Subscription> subscriptions;
  final int loyaltyPoints;
  final int vipLevel;

  Customer(
      {required this.customerId,
      required this.subscriptions,
      required this.userName,
      required this.loyaltyPoints,
      required this.vipLevel});
}
