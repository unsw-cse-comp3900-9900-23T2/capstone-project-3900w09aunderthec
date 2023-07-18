import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:under_the_c_app/components/events/event_create/dropdown_list.dart';
import 'package:under_the_c_app/components/events/event_create/tags.dart';
import 'package:under_the_c_app/config/routes/routes.dart';
import 'package:under_the_c_app/config/session_variables.dart';
import 'package:under_the_c_app/providers/event_providers.dart';
import 'package:under_the_c_app/types/address_type.dart';
import 'package:under_the_c_app/types/events/event_type.dart';

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
            onPressed: () => context.go(AppRoutes.events),
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

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create event form
class MyCustomFormState extends ConsumerState<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String time = '';
  DateTime? chosenDate = DateTime.now();
  TimeOfDay? dayTime = TimeOfDay.now();
  String venue = '';
  String description = '';
  // String ticketType = '';
  // String ticketPrice = '';
  bool isDirectRefunds = true;
  bool isPrivateEvent = true;
  String tags = 'Other';

  List<bool> selectedEventTypes = <bool>[true, false];

  void handleSelectionChanged(List<bool> newSelection) {
    setState(() {
      selectedEventTypes = newSelection;
    });
  }

  void saveSelectedTime(TimeOfDay? time) {
    setState(() {
      dayTime = time;
    });
  }

  void saveSelectedDate(DateTime? date) {
    setState(() {
      chosenDate = date;
    });
  }

  String formatTime(int time) {
    return time.toString().padLeft(2, '0');
  }

  // Future<http.Response> createEvent() {
  //   final url = Uri.https('10.0.2.2:7161', '/EventCreation/CreateEvent');
  //   final headers = {'Content-Type': 'application/json'};
  // final body = jsonEncode({
  //   "uid": 1,
  //   'title': title,
  //   "time": time,
  //   'venue': venue,
  //   'description': description,
  //   'isDirectRefunds': isDirectRefunds,
  //   'isPrivateEvent': isPrivateEvent,
  //   'tags': tags,
  // });
  //   return http.post(url, headers: headers, body: body);
  // }

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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Text(
              "Date",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: DatePicker(
              restorationId: 'main',
              saveDate: saveSelectedDate,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Text(
              "Time",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: TimePicker(
              themeMode: ThemeMode.dark,
              useMaterial3: true,
              getTime: saveSelectedTime,
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
                  isPrivateEvent = handleSelectionChanged[0];
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
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );

                    _formKey.currentState!.save();

                    time =
                        "${chosenDate!.year}-${formatTime(chosenDate!.month)}-${formatTime(chosenDate!.day)}T${formatTime(dayTime!.hour)}:${formatTime(dayTime!.minute)}:00.226Z";
                    // ref
                    //     .read(eventsProvider.notifier)
                    //     .addEvent(
                    //       Event(
                    //         hostuid: sessionVariables.uid.toString(),
                    //         title: title,
                    //         time: time,
                    //         venue: venue,
                    //         description: description,
                    //         isDirectRefunds: isDirectRefunds,
                    //         isPrivate: isPrivateEvent,
                    //         tags: [tags],
                    //         price: 0,
                    //       ),
                    //     )
                    //     // avoiding the currency issue of fetching events happening after add events
                    //     .then(
                    //   (_) {
                    //     final uid = sessionVariables.uid.toString();
                    //     ref
                    //         .read(eventsByUserProvider(uid).notifier)
                    //         .fetchEvents(uid)
                    //         .then((_) {
                    //       context.go(AppRoutes.events);
                    //     });
                    //   },
                    // );
                    await ref.read(eventsProvider.notifier).addEvent(
                          Event(
                            hostuid: sessionVariables.uid.toString(),
                            title: title,
                            time: time,
                            venue: venue,
                            description: description,
                            isDirectRefunds: isDirectRefunds,
                            isPrivate: isPrivateEvent,
                            tags: [tags],
                            price: 0,
                          ),
                        );
                    final uid = sessionVariables.uid.toString();
                    await ref
                        .read(eventsByUserProvider(uid).notifier)
                        .fetchEvents(uid);

                    // prevent accessing context after it get disposed due to the async nature
                    if (context.mounted) {
                      context.go(AppRoutes.events);
                    }
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===============Components===============
// Privacy toggle button
const List<Widget> eventTypes = <Widget>[
  Text('Private'),
  Text('Public'),
];

class ToggleButton extends StatefulWidget {
  final Function(List<bool>) onSelectionChanged;
  const ToggleButton({Key? key, required this.onSelectionChanged})
      : super(key: key);

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  /* 
  if privacy
    final List<bool> _selectedEventTypes = <bool>[true, false];
  else
  */
  final List<bool> _selectedEventTypes = <bool>[true, false];

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 5),
            ToggleButtons(
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < _selectedEventTypes.length; i++) {
                    _selectedEventTypes[i] = i == index;
                  }
                });
                widget.onSelectionChanged(_selectedEventTypes);
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: Colors.red[700],
              selectedColor: Colors.white,
              fillColor: Colors.red[200],
              color: Colors.red[400],
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 80.0,
              ),
              isSelected: _selectedEventTypes,
              children: eventTypes,
            ),
          ],
        ),
      ),
    );
  }
}

// Pick time in 12hr format
class TimePicker extends StatefulWidget {
  const TimePicker({
    super.key,
    required this.themeMode,
    required this.useMaterial3,
    required this.getTime,
  });

  final ThemeMode themeMode;
  final bool useMaterial3;
  final ValueChanged<TimeOfDay?> getTime;

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  TimeOfDay? selectedTime;
  TimePickerEntryMode entryMode = TimePickerEntryMode.dial;
  Orientation? orientation;
  TextDirection textDirection = TextDirection.ltr;
  MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;
  bool use24HourTime = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    child: const Text('Time picker'),
                    onPressed: () async {
                      final TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: selectedTime ?? TimeOfDay.now(),
                        initialEntryMode: entryMode,
                        orientation: orientation,
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              materialTapTargetSize: tapTargetSize,
                            ),
                            child: Directionality(
                              textDirection: textDirection,
                              child: MediaQuery(
                                data: MediaQuery.of(context).copyWith(
                                  alwaysUse24HourFormat: use24HourTime,
                                ),
                                child: child!,
                              ),
                            ),
                          );
                        },
                      );
                      setState(() {
                        selectedTime = time;
                        widget.getTime(time);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Pick date
class DatePicker extends StatefulWidget {
  const DatePicker({super.key, this.restorationId, required this.saveDate});

  final String? restorationId;
  final Function(DateTime?) saveDate;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> with RestorationMixin {
  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  @pragma('vm:entry-point')
  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365 * 20)),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
      });
      widget.saveDate(newSelectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        child: OutlinedButton(
          onPressed: () {
            _restorableDatePickerRouteFuture.present();
          },
          child: const Text('Date Picker'),
        ),
      ),
    );
  }
}
