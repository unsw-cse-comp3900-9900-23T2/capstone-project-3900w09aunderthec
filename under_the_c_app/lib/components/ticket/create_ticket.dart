// Button in each individual event
// Pull up data for tickets

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:under_the_c_app/api/send_email.dart';
import 'package:under_the_c_app/config/routes/routes.dart';
import 'package:under_the_c_app/providers/ticket_providers.dart';
import '../../api/ticket_requests.dart';
import 'display_ticket.dart';

final newTicketProvider = StateProvider<Map<String, dynamic>>((ref) => {});

class CreateTicket extends ConsumerWidget {
  final String eventId;

  const CreateTicket({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketData = ref.watch(newTicketProvider.notifier).state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Creation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            _buildFormRow(
              title: 'Ticket Name',
              hintText: 'Enter ticket name',
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
            ElevatedButton(
              onPressed: () {
                print('Ticket created');
              },
              child: const Text('Create Ticket'),
            ),
          ],
        ),
      ),
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
