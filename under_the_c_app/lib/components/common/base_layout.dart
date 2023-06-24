import 'package:flutter/material.dart';
import 'package:under_the_c_app/components/common/navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BaseLayout extends StatelessWidget {
  final Widget body;
  final String title;

  const BaseLayout({Key? key, required this.body, this.title = "Home"})
      : super(key: key);

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    // return Column(
    //   children: [Expanded(child: body), const NavigationBarCustom()],
    // );
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: [
        ElevatedButton(onPressed: signOut, child: const Text('Log Out')),
      ]),
      body: body,
      bottomNavigationBar: const NavigationBarCustom(),
    );
  }
}
