import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NavigationBarCustom extends ConsumerStatefulWidget {
  const NavigationBarCustom({super.key});

  @override
  ConsumerState<NavigationBarCustom> createState() => _NavigationBarCustom();
}

class _NavigationBarCustom extends ConsumerState<NavigationBarCustom> {
  int currentPageIdx = 2;

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
