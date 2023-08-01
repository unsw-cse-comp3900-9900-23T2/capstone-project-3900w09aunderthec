import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:under_the_c_app/components/ticket/date_helpers.dart';
import 'package:under_the_c_app/config/routes/routes.dart';

import '../../api/ticket_requests.dart';

final newTicketProvider = StateProvider<Map<String, dynamic>>((ref) => {});

class CreateTicket extends ConsumerStatefulWidget {
  final String eventId;

  const CreateTicket({
    super.key,
    required this.eventId,
  });

  @override
  _CreateTicket createState() => _CreateTicket();
}

class _CreateTicket extends ConsumerState<CreateTicket> {
  // prolly dont even need this, can just set straight away
  DateTime? chosenDate;
  TimeOfDay? dayTime;

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

  @override
  Widget build(BuildContext context) {
    final ticketData = ref.watch(newTicketProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Ticket Type'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              _buildFormRow(
                title: 'Ticket Name',
                hintText: 'Enter ticket type',
                onChanged: (value) {
                  ref.read(newTicketProvider.notifier).state = {
                    ...ticketData,
                    'name': value,
                  };
                },
              ),
              _buildFormRow(
                title: 'Price',
                hintText: 'Enter ticket price',
                onChanged: (value) {
                  ref.read(newTicketProvider.notifier).state = {
                    ...ticketData,
                    'price': value,
                  };
                },
              ),
              _buildFormRow(
                title: 'Amount',
                hintText: 'Enter amount of available tickets',
                onChanged: (value) {
                  ref.read(newTicketProvider.notifier).state = {
                    ...ticketData,
                    'amount': value,
                  };
                },
              ),
              const Text(
                "Select Time for Release",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: DatePicker(
                  restorationId: 'main',
                  saveDate: saveSelectedDate,
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
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  if (chosenDate != null && dayTime != null) {
                    String time =
                        "${chosenDate!.year}-${formatTime(chosenDate!.month)}-${formatTime(chosenDate!.day)}T${formatTime(dayTime!.hour)}:${formatTime(dayTime!.minute)}:00.226Z";

                    ref.read(newTicketProvider.notifier).state = {
                      ...ref.read(newTicketProvider.notifier).state,
                      'availableTime': time,
                    };

                    createTickets(ref.read(newTicketProvider.notifier).state,
                        widget.eventId);
                    context.go(AppRoutes.events);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Field Error'),
                          content: const Text(
                              'Please fill in all fields including date time!'),
                          actions: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Create Ticket'),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false, // Avoid keyboard overflows
    );
  }

  Widget _buildFormRow({
    required String title,
    required String hintText,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(),
          ),
          onChanged: onChanged,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
