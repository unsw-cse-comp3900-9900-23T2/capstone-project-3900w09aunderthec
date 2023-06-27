import 'package:under_the_c_app/components/common/types/subscription_type.dart';

class Customer {
  final int customerId;
  final List<Subscription> subscriptions;
  final int loyaltyPoints = 0;
  final int vipLevel = 0;

  Customer({required this.customerId, required this.subscriptions});
}
