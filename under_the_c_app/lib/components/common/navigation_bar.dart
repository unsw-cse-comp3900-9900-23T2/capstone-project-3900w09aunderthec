import 'package:flutter/material.dart';

class NavigationBarCustom extends StatefulWidget {
  const NavigationBarCustom({super.key});

  @override
  State<NavigationBarCustom> createState() => _NavigationBarCustom();
}

class _NavigationBarCustom extends State<NavigationBarCustom> {
  int currentPageIdx = 0;

  @override
  Widget build(BuildContext) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIdx = index;
          });
        },
        selectedIndex: currentPageIdx,
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.analytics), label: "Analytics"),
          NavigationDestination(icon: Icon(Icons.event), label: "My Events"),
          NavigationDestination(icon: Icon(Icons.create), label: "Create Events"),
          NavigationDestination(icon: Icon(Icons.create), label: "Create Events"),
        ],
      ),
    );
  }
}
