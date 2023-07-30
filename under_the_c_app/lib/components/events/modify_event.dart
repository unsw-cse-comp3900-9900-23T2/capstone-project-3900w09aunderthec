// check if the event is made by event host
// reuse event form from create_event
// Have all values of most recent save
// Save (Save button) or discard changes (everything else)

// Another idea is to merge this with create_event

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/routes/routes.dart';
import '../../providers/event_providers.dart';
import '../../types/events/event_type.dart';
import 'event_create/dropdown_list.dart';
import 'event_create/tags.dart';
import 'package:under_the_c_app/config/session_variables.dart';

// TODO:
// First, pull all previous variables
// Resave all variables and submit to backend (make sure it matches database)

class EventModify extends StatelessWidget {
  const EventModify({super.key, required this.eventId});
  final String eventId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: null,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
            onPressed: () =>
                context.go(AppRoutes.eventDetails(eventId), extra: 'Details'),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyCustomForm(
              eventId: eventId,
            ),
          ],
        ),
      ),
    );
  }
}

class MyCustomForm extends ConsumerWidget {
  MyCustomForm({
    required this.eventId,
    Key? key,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final String eventId;
  late String title;
  late String time;
  late DateTime? chosenDate;
  late TimeOfDay? dayTime;
  late String venue;
  late String description;
  late bool isDirectRefunds;
  late bool privateEvent;
  late String tags;
  late List<bool> selectedEventTypes;

  String formatTime(int time) {
    return time.toString().padLeft(2, '0');
  }

  void handleSelectionChanged(List<bool> newSelection) {
    selectedEventTypes = newSelection;
  }

  void saveSelectedTime(TimeOfDay? time) {
    dayTime = time;
  }

  void saveSelectedDate(DateTime? date) {
    chosenDate = date;
  }

  Future<List<String>> _fetchDroppedItems() async {
    // List<String> droppedItems = await getTags(title, description, venue);
    List<String> droppedItems = await getTags("string", "string", "string");
    return droppedItems;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final event = ref.watch(eventProvider(eventId));

    return event.when(
        data: (event) {
          title = event.title;
          time = event.time;
          chosenDate = DateTime.parse(event.time);
          dayTime = TimeOfDay.fromDateTime(DateTime.parse(event.time));
          venue = event.venue;
          description = event.description;
          isDirectRefunds = event.isDirectRefunds!;
          privateEvent = event.isPrivate!;
          tags = event.tags![0];
          // List<String>? tags = event.tags;

          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Center(
                    child: Text("Modify Event Form",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                ),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Event Title",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  width: 5,
                                )),
                                hintText: "Enter the name of the event"),
                            initialValue: event.title,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Event Location",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  width: 5,
                                )),
                                hintText:
                                    "Enter the place where the event is held"),
                            initialValue: event.venue,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Event Description",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  width: 5,
                                )),
                                hintText: "Write a short summary of the event"),
                            maxLines: 4,
                            initialValue: event.description,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: DatePicker(
                    restorationId: 'main',
                    saveDate: saveSelectedDate,
                    initialDate: DateTime.parse(event.time),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: TimePicker(
                    themeMode: ThemeMode.dark,
                    useMaterial3: true,
                    getTime: saveSelectedTime,
                    initialTime:
                        TimeOfDay.fromDateTime(DateTime.parse(event.time)),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: ToggleButton(
                      onSelectionChanged: (handleSelectionChanged) {
                        privateEvent = handleSelectionChanged[0];
                      },
                      selectedEventTypes: [
                        event.isPrivate ?? true,
                        !(event.isPrivate ?? false),
                      ],
                      boolList: eventTypes,
                    )),

                // Refund Button
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: Text(
                    "Refund Policy",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: ToggleButton(
                      onSelectionChanged: (handleSelectionChanged) {
                        isDirectRefunds = handleSelectionChanged[0];
                      },
                      selectedEventTypes: [
                        event.isDirectRefunds ?? true,
                        !(event.isDirectRefunds ?? false),
                      ],
                      boolList: refundType,
                    )),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: Text(
                    "Event Tags",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: FutureBuilder<List<String>>(
                    future: _fetchDroppedItems(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return DropdownList(
                          droppedItem: snapshot.data!,
                          onValueChanged: (String value) {
                            tags = value;
                            // tags = [value];
                          },
                          initial: tags,
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const CircularProgressIndicator();
                      }
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
                          ref.read(eventsProvider.notifier).changeEvent(
                                Event(
                                  hostuid: sessionVariables.uid.toString(),
                                  eventId: eventId,
                                  title: title,
                                  time: time,
                                  venue: venue,
                                  description: description,
                                  isDirectRefunds: isDirectRefunds,
                                  isPrivate: privateEvent,
                                  // tags: [tags],
                                  price: 0,
                                ),
                              );
                          final uid = sessionVariables.uid.toString();
                          ref.read(eventsProvider.notifier).fetchEvents;
                          ref
                              .read(eventsByUserProvider(uid).notifier)
                              .fetchEvents(uid);

                          context.go(AppRoutes.eventDetails(eventId),
                              extra: 'Details');
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        error: (err, stack) => Text("Error: $err"),
        loading: () => const CircularProgressIndicator());
  }
}

// ===============Components===============
// Privacy toggle button
const List<Widget> eventTypes = <Widget>[
  Text('Private'),
  Text('Public'),
];

const List<Widget> refundType = <Widget>[
  Text('Credit Refund'),
  Text('No Refund'),
];

class ToggleButton extends StatefulWidget {
  final Function(List<bool>) onSelectionChanged;
  final List<Widget> boolList;
  const ToggleButton(
      {Key? key,
      required this.onSelectionChanged,
      required this.selectedEventTypes,
      required this.boolList})
      : super(key: key);

  final List<bool> selectedEventTypes;

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
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
                  for (int i = 0; i < widget.selectedEventTypes.length; i++) {
                    widget.selectedEventTypes[i] = i == index;
                  }
                });
                widget.onSelectionChanged(widget.selectedEventTypes);
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
              isSelected: widget.selectedEventTypes,
              children: widget.boolList,
            ),
          ],
        ),
      ),
    );
  }
}

// Pick time in 12hr format
class TimePicker extends StatefulWidget {
  const TimePicker(
      {super.key,
      required this.themeMode,
      required this.useMaterial3,
      required this.getTime,
      required this.initialTime});

  final ThemeMode themeMode;
  final bool useMaterial3;
  final ValueChanged<TimeOfDay?> getTime;
  final TimeOfDay initialTime;

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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ElevatedButton(
                    child: Text(selectedTime != null
                        ? (selectedTime?.format(context) ?? "")
                        : widget.initialTime.format(context)),
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
  const DatePicker(
      {super.key,
      this.restorationId,
      required this.saveDate,
      required this.initialDate});

  final String? restorationId;
  final Function(DateTime?) saveDate;
  final DateTime initialDate;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> with RestorationMixin {
  DateTime nullDate = DateTime(
      DateTime.now().year - 1, DateTime.now().month, DateTime.now().day);

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
        nullDate = newSelectedDate;
        _selectedDate.value = newSelectedDate;
      });
      widget.saveDate(newSelectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: OutlinedButton(
          onPressed: () {
            _restorableDatePickerRouteFuture.present();
          },
          child: Text(
            nullDate !=
                    DateTime(DateTime.now().year - 1, DateTime.now().month,
                        DateTime.now().day)
                ? '${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'
                : '${widget.initialDate.day}/${widget.initialDate.month}/${widget.initialDate.year}',
          ),
        ),
      ),
    );
  }
}
