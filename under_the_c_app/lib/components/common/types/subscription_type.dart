import 'package:under_the_c_app/components/common/types/events/event_type.dart';
import 'package:under_the_c_app/components/common/types/users/customer_type.dart';

class Subscription {
  final int eventIdRef;
  final Event toEvent;

  final int customerIdRef;
  final Customer customer;

  Subscription(
      {required this.eventIdRef,
      required this.toEvent,
      required this.customerIdRef,
      required this.customer});
}
