import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/layout/navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:under_the_c_app/config/session_variables.dart';
import 'package:under_the_c_app/providers/booking_providers.dart';

class BaseLayout extends ConsumerWidget {
  final Widget body;
  final String title;
  final bool isHost;

  const BaseLayout(
      {Key? key, this.title = "Home", required this.body, required this.isHost})
      : super(key: key);

  void signOut() async {
    FirebaseAuth.instance.signOut();

    // reset the bookings
    final uid = sessionVariables.uid;
    // final container = ProviderContainer();
    // container.refresh(bookingsProvider(uid.toString()));

    //reset the session
    sessionVariables.resetVariables();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          ElevatedButton(
            onPressed: signOut,
            child: const Text('Log Out'),
            style: ElevatedButton.styleFrom(elevation: 0),
          ),
        ],
      ),
      body: body,
      bottomNavigationBar: NavigationBarCustom(isHost: isHost),
    );
  }
}
