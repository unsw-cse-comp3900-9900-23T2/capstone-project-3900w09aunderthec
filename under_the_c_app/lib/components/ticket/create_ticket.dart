import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
              const SizedBox(height: 30),
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
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: DatePicker(
                  restorationId: 'main',
                  saveDate: saveSelectedDate,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  createTickets(ticketData, eventId);
                  context.go(AppRoutes.events);
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
