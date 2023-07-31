import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:under_the_c_app/config/routes/routes.dart';
import 'package:under_the_c_app/config/session_variables.dart';

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
    List<NavigationDestination> destinations = [];
    if (widget.isHost == true) {
      destinations.add(const NavigationDestination(
          icon: Icon(Icons.analytics), label: "Analytics"));
    }
    destinations.addAll([
      const NavigationDestination(icon: Icon(Icons.event), label: "Events"),
      const NavigationDestination(icon: Icon(Icons.home), label: "My Home"),
      const NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
    ]);
    return NavigationBar(
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIdx = index;
        });
        switch (index) {
          case 0:
            // analytics page for host, events page for the customers
            if (widget.isHost == true) {
              context.go(AppRoutes.analytics, extra: 'Analytics');
            } else {
              context.go(AppRoutes.events, extra: 'Events');
            }
            sessionVariables.navLocation = 0;
            break;
          case 1:
            // events page for host, home page for the customers
            if (widget.isHost == true) {
              context.go(AppRoutes.events, extra: 'Events');
            } else {
              context.go(AppRoutes.home, extra: 'Home');
            }
            sessionVariables.navLocation = 1;
            break;
          case 2:
            if (widget.isHost == true) {
              context.go(AppRoutes.home, extra: 'Home');
            } else {
              context.go(AppRoutes.profile, extra: 'Profile');
            }
            sessionVariables.navLocation = 2;
            break;

          case 3:
            if (widget.isHost == true) {
              context.go(AppRoutes.profile, extra: 'Profile');
            }

          default:
            break;
        }
      },
      selectedIndex: currentPageIdx,
      destinations: destinations,
    );
  }
}
