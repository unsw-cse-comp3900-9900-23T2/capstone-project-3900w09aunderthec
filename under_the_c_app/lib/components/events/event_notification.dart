import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/routes/routes.dart';

final eventNotificationProvider =
    StateProvider<Map<String, dynamic>>((ref) => {});

class EventNotificationPage extends ConsumerWidget {
  final eventId;

  const EventNotificationPage({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationData = ref.watch(eventNotificationProvider);

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
                title: 'Notification Subject',
                hintText: 'Enter subject',
                height: 50,
                onChanged: (value) {
                  ref.read(eventNotificationProvider.notifier).state = {
                    ...notificationData,
                    'name': value,
                  };
                },
              ),
              _buildFormRow(
                title: 'Notification Message',
                hintText: 'Enter Message',
                height: 300,
                onChanged: (value) {
                  ref.read(eventNotificationProvider.notifier).state = {
                    ...notificationData,
                    'price': value,
                  };
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  //createTicksets(ticketData, eventId);
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
    required int height,
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
