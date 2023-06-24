import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/components/common/navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:under_the_c_app/config/app_router.dart';

class BaseLayout extends ConsumerWidget {
  final Widget body;
  final String title;

  const BaseLayout({Key? key, this.title = "Home", required this.body})
      : super(key: key);

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: [
        ElevatedButton(onPressed: signOut, child: const Text('Log Out')),
      ]),
      body: body,
      bottomNavigationBar: const NavigationBarCustom(),
    );
  }
}
