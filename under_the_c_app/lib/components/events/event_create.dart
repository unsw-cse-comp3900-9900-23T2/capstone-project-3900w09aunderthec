import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:under_the_c_app/api/events/http_event_requests.dart';
import 'package:under_the_c_app/providers/event_providers.dart';
import 'package:under_the_c_app/types/events/event_type.dart';
import 'package:under_the_c_app/types/location/address.dart';
import 'widgets/dropdown_list.dart';
import 'widgets/toggle_button.dart';
import 'dart:convert';
import 'date/date_picker.dart';

class EventCreate extends StatelessWidget {
  const EventCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: null,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
            onPressed: () => context.go('/host/events'),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyCustomForm(),
          ],
        ),
      ),
    );
  }
}

// Create a question and input box
class FormFields extends StatelessWidget {
  const FormFields({Key? key, required this.fieldName, required this.hint})
      : super(key: key);
  final String fieldName;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          DefaultTextStyle(
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            child: Text(fieldName),
          ),
          TextFormField(
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                    borderSide: BorderSide(
                  width: 5,
                )),
                hintText: hint),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please fill out the required field';
              }
              return null;
            },
          ),
        ]));
  }
}

class MyCustomForm extends ConsumerStatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  // @override
  // MyCustomFormState createState() {
  //   return MyCustomFormState();
  // }
  @override
  MyCustomFormState createState() => MyCustomFormState();
}

// Create event form
class MyCustomFormState extends ConsumerState<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  String title = '';
  DateTime time = DateTime.now();
  String venue = '';
  String description = '';
  // String ticketType = '';
  // String ticketPrice = '';
  bool allowRefunds = true;
  bool privateEvent = true;
  String tags = 'Other';

  List<bool> selectedEventTypes = <bool>[true, false];

  void handleSelectionChanged(List<bool> newSelection) {
    setState(() {
      selectedEventTypes = newSelection;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: DefaultTextStyle(
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                child: Center(
                  child: Text("Create Event Form",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                )),
          ),
          // Title
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Event Title",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                            width: 5,
                          )),
                          hintText: "Enter the name of the event"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please fill out the required field';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        title = value ?? '';
                      },
                    ),
                  ])),

          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Event Location",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                            width: 5,
                          )),
                          hintText: "Enter the place where the event is held"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please fill out the required field';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        venue = value ?? '';
                      },
                    ),
                  ])),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Event Description",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                            width: 5,
                          )),
                          hintText: "Write a short summary of the event"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please fill out the required field';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        description = value ?? '';
                      },
                    ),
                  ])),
          // Date & Time
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: DefaultTextStyle(
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              child: Text("Date & Time"),
            ),
          ),
          // const DatePickerApp(),
          // TODO: [PLHV-158] event_create.dart: MyCustomFormState: Check for valid date and time (Can't be before today)
          // Privacy Button
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Text(
              "Privacy",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: ToggleButton(
                onSelectionChanged: (handleSelectionChanged) {
                  privateEvent = handleSelectionChanged[0];
                },
              )),
          // Ticket type
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Text("Tickets",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Table(
              border: TableBorder.all(color: Colors.black),
              columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(),
              },
              children: [
                const TableRow(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: Text('Ticket Type'),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: Text('Price'),
                    )
                  ],
                ),
                TableRow(children: [
                  TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 5,
                        )),
                        hintText: "Type"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please fill out the required field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 5,
                        )),
                        hintText: "Amount"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please fill out the required field';
                      }
                      return null;
                    },
                  ),
                ]),
              ],
            ),
          ),
          // FormFields(
          //     fieldName: "Refund Policy", hint: ""),
          // FormFields(
          //     fieldName: "Comments", hint: ""),
          // Event Tags
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Text(
              "Event Tags",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: DropdownList(
              droppedItem: droppedItems,
              initial: 'Other',
              onValueChanged: (String value) {
                tags = value;
              },
            ),
          ),
          // Submit Button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );

                  _formKey.currentState!.save();

                  ref.read(eventsProvider.notifier).addEvent(
                      // TODO: [PLHV-199] event_creation.dart: Need to pass the variables below(except suburb, city, country, postcode maybe)
                      Event(
                          title: title,
                          price: 0,
                          address: Address(
                              venue: venue,
                              suburb: "",
                              city: "",
                              country: "",
                              postalCode: ""),
                          time: "2023-06-27T10:15:33.226Z"),
                      "1");
                  context.go('/host/events');
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}

// List for Tags
List<DropdownMenuItem<String>> get droppedItems {
  List<DropdownMenuItem<String>> eventType = [
    const DropdownMenuItem(
      value: "Arts",
      child: Text("Arts"),
    ),
    const DropdownMenuItem(
      value: "Business",
      child: Text("Business"),
    ),
    const DropdownMenuItem(
      value: "Comedy",
      child: Text("Comedy"),
    ),
    const DropdownMenuItem(
      value: "Food & Drink",
      child: Text("Food & Drink"),
    ),
    const DropdownMenuItem(
      value: "Fashion",
      child: Text("Fashion"),
    ),
    const DropdownMenuItem(
      value: "Music",
      child: Text("Music"),
    ),
    const DropdownMenuItem(
      value: "Sports",
      child: Text("Sports"),
    ),
    const DropdownMenuItem(
      value: "Science",
      child: Text("Science"),
    ),
    const DropdownMenuItem(
      value: "Other",
      child: Text("Other"),
    ),
  ];
  return eventType;
}
