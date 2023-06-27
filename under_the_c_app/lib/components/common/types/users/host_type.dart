
import 'package:under_the_c_app/components/common/types/events/event_type.dart';
import 'package:under_the_c_app/components/common/types/subscription_type.dart';
import 'package:under_the_c_app/components/common/types/users/user_type.dart';

class Host extends User{
  final List<Event> events;
  final List<Subscription> subscriptions;
  final String organisationName;
  Host(this.events, this.subscriptions, this.organisationName, {required super.name, required super.userName});
}