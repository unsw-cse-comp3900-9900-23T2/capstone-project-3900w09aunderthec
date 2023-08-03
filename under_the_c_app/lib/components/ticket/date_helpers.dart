// Pick time in 12hr format
import 'package:flutter/material.dart';

// Widget to select time for ticket release
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ElevatedButton(
                    child: Text(selectedTime != null
                        ? (selectedTime?.format(context) ?? "")
                        : "Time Picker"),
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

// Widget to select date for ticket release
class DatePicker extends StatefulWidget {
  const DatePicker({super.key, this.restorationId, required this.saveDate});

  final String? restorationId;
  final Function(DateTime?) saveDate;

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
          child: Text(nullDate !=
                  DateTime(DateTime.now().year - 1, DateTime.now().month,
                      DateTime.now().day)
              ? '${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'
              : "Date Picker"),
        ),
      ),
    );
  }
}

String formatTime(int time) {
  return time.toString().padLeft(2, '0');
}
