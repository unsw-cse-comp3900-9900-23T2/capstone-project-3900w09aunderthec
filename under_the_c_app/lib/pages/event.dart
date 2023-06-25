import 'package:flutter/material.dart';
// import 'package:flutter_application_1/toggle_button.dart';
// import 'toggle_button.dart';
// import 'hover.dart';
// import 'create_event.dart';

class EventPage extends StatelessWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.lightBlue,
        alignment: Alignment.center,
        child: const Text("Event Page"));
  }
}
// void main() {
//   // runApp(const MyApp());
//   runApp(const MaterialApp(
//     title: "Create Event",
//     home: HomeRoute(),
//   ));
// }

// class HomeRoute extends StatelessWidget {
//   const HomeRoute({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Home"),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 20.0),
//             child: GestureDetector(onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => const CreateEventRoute()),
//               );
//             }, child: HoverBuilder(builder: (isHovered) {
//               return Icon(
//                 Icons.add_outlined,
//                 size: 20.0,
//                 color: isHovered ? Colors.grey : Colors.white,
//                 // child: const Text("Create event"),
//               );
//             })),
//           )
//         ],
//       ),
//     );
//   }
// }
