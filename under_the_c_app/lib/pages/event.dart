import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
<<<<<<< HEAD
// import 'package:flutter_application_1/toggle_button.dart';
// import 'toggle_button.dart';
// import 'hover.dart';
// import 'create_event.dart';
=======
import 'package:http/io_client.dart';
>>>>>>> e545a3829fb53618e54a113d0c8348cd8e6f6744

class EventPage extends StatelessWidget {
  const EventPage({Key? key}) : super(key: key);

  void getEvents() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    var ioClient = IOClient(client);

    final registerUrl = Uri.https('10.0.2.2:7161', '/EventDisplay/ListEvents');

    try {
      final response = await ioClient.post(
        registerUrl,
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*'
        },
        body: jsonEncode({
          // TO-DO change UID to possibly the email
          "uid": "1"
        }),
      );

      // server currently returns a 500 as its not implemented
      if (response.statusCode == 500) {
        print(response.body);
        throw Exception(response.body);
      }
    } catch (e) {
      print('An error occured: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.lightBlue,
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: getEvents,
          child: const Text("Event Page"),
        ));
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
