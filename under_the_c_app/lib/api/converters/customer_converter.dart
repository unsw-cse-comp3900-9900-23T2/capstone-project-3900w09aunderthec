import 'package:under_the_c_app/types/events/event_type.dart';
import 'package:under_the_c_app/types/users/customer_type.dart';

// List<Customer> BackendDataCustomerListToCustomer(data) {
//   List<Customer> customers = [];
//   for (var customer in data) {
//     events.add(
//       Event(
//         hostuid: event.hosterId.toString(),
//         title: event.title,
//         eventId: event.eventId.toString(),
//         imageUrl: 'images/events/money-event.jpg',
//         time: event.time.toString(),
//         venue: event.venue,
//         price: 0,
//         description: event.description,
//       ),
//     );
//   }
//   return events;
// }

Customer backendDataSingleCustomerToCustomer(data) {
  return Customer(
    customerId: data['uid'],
    subscriptions: [],
    userName: data['username'],
    loyaltyPoints: data['loyaltyPoints'] ?? 0,
    vipLevel: data['vipLevel'] ?? 0,
  );
}
