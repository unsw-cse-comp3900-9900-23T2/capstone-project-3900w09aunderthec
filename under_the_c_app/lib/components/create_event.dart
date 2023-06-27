import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'switch_button.dart';
import 'dropdown_list.dart';
import 'toggle_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'date_picker.dart';

// TODO: Save all variables and submit to backend (make sure it matches database)

class CreateEventRoute extends StatelessWidget {
  // const CreateEventRoute({super.key});
  const CreateEventRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Event"),
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

class MyCustomForm extends StatefulWidget {
  // const MyCustomForm({super.key});
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create event form
class MyCustomFormState extends State<MyCustomForm> {
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

  Future<http.Response> createEvent() {
    // TODO: Fix datetime
    // print(time);
    // String formattedDate = DateFormat.yMMMEd().format(time);
    // print(formattedDate);

    final url = Uri.https('10.0.2.2:7161', '/EventCreation/CreateEvent');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "uid": 1,
      'title': title,
      // yyyy-MM-dd HH:mm:ss
      // 'time': "2023-06-27 14:56:45",
      "time": "2023-06-27T10:15:33.226Z",
      'venue': venue,
      'description': description,
      'allowRefunds': allowRefunds,
      'privateEvent': privateEvent,
      'tags': tags,
    });
    return http.post(url, headers: headers, body: body);
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
            child: Center(
              child: Text("Create Event Form",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
          ),
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
          // TODO: Change it up
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Text("Date & Time",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          // Center(
          //     child: RaisedButton(
          //         child: Text('click'),
          //         onPressed: () {
          //           selectDate(context);
          //           DatePickerApp(key: ,),
          //         })),
          const DatePickerApp(),
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
              // onSelectionChanged: handleSelectionChanged,
              onSelectionChanged: (handleSelectionChanged) {
                privateEvent = handleSelectionChanged[0];
              },
            ),
          ),
          // Old privacy button
          // const Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          //   child: SwitchButton(),
          // ),
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
              initial: "Other",
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

                  createEvent().then((response) {
                    if (response.statusCode == 200) {
                      // Event created successfully
                      // Handle success case
                    } else {
                      // Event creation failed
                      // Handle error case
                      throw Exception(
                          'Failed to CREATE event: ${response.body}');
                    }
                    Navigator.pop(context);
                  });
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