import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../dropdown_list.dart';
import '../time_picker.dart';
import '../toggle_button.dart';
import 'dart:convert';
import '../date_picker.dart';
import 'tags.dart';

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

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
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
          // TODO: Change it up
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Text(
              "Date",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: DatePicker(restorationId: 'main'),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Text(
              "Time",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: TimePicker(
              themeMode: ThemeMode.dark,
              useMaterial3: true,
            ),
          ),

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

                  createEvent().then((response) {
                    if (response.statusCode == 200) {
                      // Event created successfully
                    } else {
                      // Event creation failed
                      throw Exception(
                          'Failed to CREATE event: ${response.body}');
                    }
                    context.go('/host/events');
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
