import 'package:under_the_c_app/types/events/event_type.dart';
import 'package:under_the_c_app/types/users/customer_type.dart';

// List<Customer> BackendDataCustomerListToCustomer(data) {
//   List<Customer> customers = [];
//   for (var customer in data) {
//     events.add(
//       Event(
//         hostuid: event.hosterFK.toString(),
//         title: event.title,
//         eventId: event.eventId.toString(),
//         imageUrl: 'images/events/money-event.jpg',
//         time: event.time.toString(),
//         venue: event.venue,
//         // TODO: [PLHV-198] EventCreate: We need set up price in the backend, can't always have price = 0.
//         price: 0,
//         description: event.description,
//       ),
//     );
//   }
//   return events;
// }

Customer BackendDataSingleCustomerToCustomer(data) {
  return Customer(
    customerId: data['uid'],
    subscriptions: [],
    userName: data['username'],
  );
}
