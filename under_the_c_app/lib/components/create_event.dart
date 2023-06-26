import 'package:flutter/material.dart';
import 'switch_button.dart';
import 'dropdown_list.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'toggle_button.dart';

// TODO: Save all variables and submit to backend (make sure it matches database)

class CreateEventRoute extends StatelessWidget {
  const CreateEventRoute({super.key});

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
  const MyCustomForm({super.key});

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
          Text(
            fieldName,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

// Create event form
class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

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
          const FormFields(
              fieldName: "Event Title", hint: "Enter the name of the event"),
          // Location
          const FormFields(
              fieldName: "Event Location",
              hint: "Enter the place where the event is held"),
          // Description
          const FormFields(
              fieldName: "Event Description",
              hint: "Write a short summary of the event"),
          // Date & Time
          // TODO: Change it up
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Text("Date & Time",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          DateTimePicker(
            type: DateTimePickerType.dateTimeSeparate,
            dateMask: 'd MMM, yyyy',
            initialValue: DateTime.now().toString(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            icon: const Icon(Icons.event),
            dateLabelText: 'Date',
            timeLabelText: "Hour",
            // TODO: Check for valid date and time (Can't be before today)
            /* 
              selectableDayPredicate: (date) {
              // Disable weekend days to select from the calendar
              if (date.weekday == 6 || date.weekday == 7) return false;
              return true;
            },
            onChanged: (val) => print(val),
            validator: (val) {
              print(val);
              return null;
            },
            onSaved: (val) => print(val),
            */
          ),
          // Privacy Button
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Text(
              "Privacy",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: ToggleButton(),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: SwitchButton(),
          ),
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
              onValueChanged: (String value) {},
            ),
          ),
          // Submit Button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                  Navigator.pop(context);
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
