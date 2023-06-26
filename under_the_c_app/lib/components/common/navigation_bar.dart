import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.analytics), label: "Analytics"),
          NavigationDestination(icon: Icon(Icons.event), label: "Events"),
          NavigationDestination(icon: Icon(Icons.home), label: "My Home"),
          NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
        ],
        onDestinationSelected: _goBranch,
      ),
    );
  }
}

// class NavigationBarCustom extends ConsumerStatefulWidget {
//   const NavigationBarCustom({super.key});

//   @override
//   ConsumerState<NavigationBarCustom> createState() => _NavigationBarCustom();
// }

// class _NavigationBarCustom extends ConsumerState<NavigationBarCustom> {
//   int currentPageIdx = 2;

//   @override
//   Widget build(BuildContext context) {
//     return NavigationBar(
//       onDestinationSelected: (int index) {
//         setState(() {
//           currentPageIdx = index;
//         });
//         switch (index) {
//           case 0:
//             context.go('/analytics');
//             break;
//           case 1:
//             print("Going to events");
//             context.go('/events');
//             break;
//           case 2:
//             context.go('/home');
//             break;
//           case 3:
//             context.go('/profile');
//             break;
//           default:
//             break;
//         }
//       },
//       selectedIndex: currentPageIdx,
//       destinations: const <Widget>[
//         NavigationDestination(icon: Icon(Icons.analytics), label: "Analytics"),
//         NavigationDestination(icon: Icon(Icons.event), label: "Events"),
//         NavigationDestination(icon: Icon(Icons.home), label: "My Home"),
//         NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
//       ],
//     );
//   }
// }
