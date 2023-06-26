// Button in each individual event
// Pull up data for tickets

import 'package:flutter/material.dart';
import '../components/dropdown_list.dart';

// List for Tags
List<DropdownMenuItem<String>> getDroppedNumbers() {
  List<DropdownMenuItem<String>> ticketType = [];
  for (int i = 0; i < 10; i++) {
    ticketType.add(DropdownMenuItem(
      value: i.toString(),
      child: Text(i.toString()),
    ));
  }
  return ticketType;
}

class BookTicketRoute extends StatelessWidget {
  const BookTicketRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Tickets"),
      ),
      body: const Column(
        children: [
          TicketForm(),
        ],
      ),
    );
  }
}

class TicketForm extends StatefulWidget {
  const TicketForm({super.key});

  @override
  TicketFormState createState() {
    return TicketFormState();
  }
}

class TicketFormState extends State<TicketForm> {
  String selectedValue = '';

  void handleDropdownValueChanged(String value) {
    setState(() {
      selectedValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const DefaultTextStyle(
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          child: Text("Event Title"),
        ),
        Text("Date"),
        Text("Location"),
        const Divider(
          height: 20,
          thickness: 1,
          indent: 20,
          endIndent: 20,
          color: Colors.black,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  child: Text("Ticket Type"),
                ),
                DefaultTextStyle(
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  child: Text("\$ 45"),
                ),
                Text("Sales end on Date - 1 day"),
              ],
            ),
            DropdownList(
              droppedItem: getDroppedNumbers(),
              initial: "0",
              onValueChanged: handleDropdownValueChanged,
            ),
          ],
        ),
        Container(
          alignment: Alignment.bottomCenter,
          color: Colors.grey,
          child: Column(
            children: [
              const Divider(
                height: 20,
                thickness: 1,
                indent: 20,
                endIndent: 20,
                color: Colors.black,
              ),
              Text("Your Order: $selectedValue * price"),
              const Divider(
                height: 20,
                thickness: 1,
                indent: 20,
                endIndent: 20,
                color: Colors.black,
              ),
              Text("Total \$ (45 * $selectedValue) "),
            ],
          ),
        ),
      ],
    );
  }
}
