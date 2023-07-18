import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/providers/event_providers.dart';

class ViewBookingPage extends ConsumerWidget {
  final String eventId;
  const ViewBookingPage({
    required this.eventId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final event = ref.watch(eventProvider(eventId));
    return event.when(
        data: (event) {
          return Text("data");
        },
        error: (err, stack) => Text("Error: $err"),
        loading: () => const CircularProgressIndicator());
  }
}
