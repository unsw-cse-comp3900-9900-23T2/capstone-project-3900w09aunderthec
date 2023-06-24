import 'package:flutter/material.dart';
import 'package:under_the_c_app/components/common/navigation_bar.dart';

class BaseLayout extends StatelessWidget {
  final Widget body;

  const BaseLayout({Key? key, required this.body, required String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NavigationBarCustom(),
      body: body,
    );
  }
}


