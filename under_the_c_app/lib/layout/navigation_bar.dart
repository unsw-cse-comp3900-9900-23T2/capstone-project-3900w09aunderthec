import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:under_the_c_app/config/routes.dart';

class NavigationBarCustom extends ConsumerStatefulWidget {
  final bool isHost;
  const NavigationBarCustom({super.key, required this.isHost});

  @override
  ConsumerState<NavigationBarCustom> createState() => _NavigationBarCustom();
}

class _NavigationBarCustom extends ConsumerState<NavigationBarCustom> {
  late int homePageIndex;
  late int currentPageIdx;

  @override
  void initState() {
    super.initState();
    homePageIndex = 1;
    currentPageIdx = homePageIndex;
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIdx = index;
        });
        switch (index) {
          case 0:
            widget.isHost
                ? context.go(AppRoutes.events, extra: 'Events')
                : context.go(AppRoutes.events, extra: 'Events');
            break;
          case 1:
            context.go('/home', extra: 'Home');
            break;
          case 2:
            context.go('/profile', extra: 'Profile');
            break;
          default:
            break;
        }
      },
      selectedIndex: currentPageIdx,
      destinations: const <Widget>[
        // NavigationDestination(icon: Icon(Icons.analytics), label: "Analytics"),
        NavigationDestination(icon: Icon(Icons.event), label: "Events"),
        NavigationDestination(icon: Icon(Icons.home), label: "My Home"),
        NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
