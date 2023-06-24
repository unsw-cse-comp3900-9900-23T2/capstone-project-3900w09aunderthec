import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:under_the_c_app/pages/analytics.dart';
import 'package:under_the_c_app/pages/event.dart';
import '../../config/app_router.dart';

class NavigationBarCustom extends ConsumerStatefulWidget {
  const NavigationBarCustom({super.key});

  @override
  ConsumerState<NavigationBarCustom> createState() => _NavigationBarCustom();
}

class _NavigationBarCustom extends ConsumerState<NavigationBarCustom> {
  int currentPageIdx = 2;

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

  // final router = ref.watch(routerProvider);

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIdx = index;
        });
        switch (index) {
          case 0:
            context.go('/analytics');
            break;
          case 1:
            context.go('/events');
            break;
          case 2:
            context.go('/home');
            break;
          case 3:
            context.go('/profile');
            break;
          default:
            break;
        }
      },
      selectedIndex: currentPageIdx,
      destinations: const <Widget>[
        NavigationDestination(icon: Icon(Icons.analytics), label: "Analytics"),
        NavigationDestination(icon: Icon(Icons.event), label: "Events"),
        NavigationDestination(icon: Icon(Icons.home), label: "My Home"),
        NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
