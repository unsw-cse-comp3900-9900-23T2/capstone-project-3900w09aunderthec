import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// class AppScaffold extends StatefulWidget {
//   const AppScaffold({Key? key, required this.child}) : super(key: key);
//   final Widget child;
//   @override
//   State<AppScaffold> createState() => _AppScaffoldState();
// }

// class _AppScaffoldState extends State<AppScaffold> {
//   int currentPageIdx = 2;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: const Text('Billion Dollar App')),
//         body: widget.child,
//         bottomNavigationBar: NavigationBar(
//           onDestinationSelected: (int index) {
//             setState(() {
//               currentPageIdx = index;
//             });
//             switch (index) {
//               case 0:
//                 context.go('/analytics');
//                 break;
//               case 1:
//                 context.go('/events');
//                 break;
//               case 2:
//                 context.go('/home');
//                 break;
//               case 3:
//                 context.go('/profile');
//                 break;
//               default:
//                 break;
//             }
//           },
//           selectedIndex: currentPageIdx,
//           destinations: const <Widget>[
//             NavigationDestination(
//                 icon: Icon(Icons.analytics), label: "Analytics"),
//             NavigationDestination(icon: Icon(Icons.event), label: "Events"),
//             NavigationDestination(icon: Icon(Icons.home), label: "My Home"),
//             NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
//           ],
//         )
//         // bottomNavigationBar: BottomNavigationBar(
//         //   currentIndex: _calculateSelectedIndex(context),
//         //   onTap: onTap,
//         //   items: const [
//         //     BottomNavigationBarItem(
//         //         icon: Icon(Icons.analytics), label: 'Analytics'),
//         //     BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
//         //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'My Home'),
//         //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         //   ],
//         // ),
//         );
//   }

// int _calculateSelectedIndex(BuildContext context) {
//   final GoRouter route = GoRouter.of(context);
//   final String location = route.location;
//   if (location.startsWith('/analytics')) {
//     return 0;
//   }
//   if (location.startsWith('/events')) {
//     return 1;
//   }
//   if (location.startsWith('/home')) {
//     return 2;
//   }
//   if (location.startsWith('/profile')) {
//     return 3;
//   }
//   return 0;
// }

//   void onTap(int value) {
//     switch (value) {
//       case 0:
//         return context.go('/analytics');
//       case 1:
//         return context.go('/events');
//       case 2:
//         return context.go('/home');
//       case 3:
//         return context.go('/profile');
//       default:
//         return context.go('/home');
//     }
//   }
// }

class NavigationBarCustom extends ConsumerStatefulWidget {
  final bool isHost;
  const NavigationBarCustom({super.key, required this.isHost});

  @override
  ConsumerState<NavigationBarCustom> createState() => _NavigationBarCustom();
}

class _NavigationBarCustom extends ConsumerState<NavigationBarCustom> {
  late int homePageIndex ;
  late int currentPageIdx;

  @override
  void initState() {
    super.initState();
    homePageIndex = 1;
    // homePageIndex = widget.isHost ?  2 : 1;
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
            widget.isHost ? 
            context.go('/host/events', extra: 'Events') : context.go('/customer/events', extra: 'Events');
            break;
          case 1:
            context.go('/home', extra: 'Home');
            break;
          case 2:
            context.go('/profile', extra: 'Profile');
            break;
          // case 3:
          //   context.go('/profile', extra: "Profile ");
          //   break;
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
