import 'package:flutter/material.dart';

class NavigationBarCustom extends StatefulWidget {
  const NavigationBarCustom({super.key});

  @override
  State<NavigationBarCustom> createState() => _NavigationBarCustom();
}

class _NavigationBarCustom extends State<NavigationBarCustom> {
  int currentPageIdx = 0;

  List<Widget> pages = <Widget>[
    Container(
      color: Colors.red,
      alignment: Alignment.center,
      child: const Text('Page 1'),
    ),
    Container(
      color: Colors.green,
      alignment: Alignment.center,
      child: const Text('Page 2'),
    ),
    Container(
      color: Colors.blue,
      alignment: Alignment.center,
      child: const Text('Page 3'),
    ),
    Container(
      color: Colors.blue,
      alignment: Alignment.center,
      child: const Text('Page 4'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return 
      NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIdx = index;
          });
        },
        selectedIndex: currentPageIdx,
        destinations: const <Widget>[
          NavigationDestination(
              icon: Icon(Icons.analytics), label: "Analytics"),
          NavigationDestination(icon: Icon(Icons.event), label: "My Events"),
          NavigationDestination(
              icon: Icon(Icons.create), label: "Create Events"),
          NavigationDestination(
              icon: Icon(Icons.create), label: "Create Events"),
        ],
    );
  }
}
