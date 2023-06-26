import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/components/common/base_layout.dart';
import 'package:under_the_c_app/components/common/navigation_bar.dart';
import 'package:under_the_c_app/components/common/types/events/event_type.dart';
import 'package:under_the_c_app/pages/main_pages/analytics.dart';
import 'package:under_the_c_app/pages/main_pages/event.dart';
import 'package:under_the_c_app/pages/main_pages/home.dart';
import 'package:under_the_c_app/pages/main_pages/profile.dart';
import 'package:under_the_c_app/pages/main_pages/register.dart';
import 'package:under_the_c_app/pages/subpages/event_details.dart';

import '../login_page.dart';
import 'auth_state_provider.dart';

final _key = GlobalKey<NavigatorState>();

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorAnalyticsKey =
    GlobalKey<NavigatorState>(debugLabel: "ShellAnalytics");
final _shellNavigatorHomeKey =
    GlobalKey<NavigatorState>(debugLabel: "ShellHome");
final _shellNavigatorEventKey =
    GlobalKey<NavigatorState>(debugLabel: "ShellEvent");
final _shellNavigatorProfileKey =
    GlobalKey<NavigatorState>(debugLabel: "ShellProfile");

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _key,
    initialLocation: '/',
    routes: [
      // GoRoute(
      //   path: '/analytics',
      //   pageBuilder: (context, state) {
      //     return const MaterialPage(child: BaseLayout(body: AnalyticsPage()));
      //   },
      // ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // the UI shell
          return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
        },
        branches: [
          // first branch (Home)
          StatefulShellBranch(
            navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'home'),
            routes: [
              // top route inside branch
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) =>
                    MaterialPage(child: HomePage()),
                routes: [
                  // child route
                  GoRoute(
                    path: 'eventDetails/:eventId',
                    pageBuilder: (context, state) {
                      final String eventId = state.params['eventId']!;
                      return MaterialPage(
                          child: ProviderScope(overrides: [
                        eventProvider.overrideWithValue(getEventById(eventId))
                      ], child: const EventDetailsPage()));
                    },
                  ),
                ],
              ),
            ],
          ),
          // // second branch (Events)
          // StatefulShellBranch(
          //   navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'events'),
          //   routes: [
          //     // top route inside branch
          //     GoRoute(
          //       path: '/events',
          //       pageBuilder: (context, state) => MaterialPage(child: EventPage()),
          //       routes: [
          //         // child route
          //         GoRoute(
          //           path: 'eventDetails/:eventId',
          //           pageBuilder: (context, state) {
          //             final String eventId = state.params['eventId']!;
          //             return MaterialPage(
          //               child: ProviderScope(
          //                 overrides: [eventProvider.overrideWithValue(getEventById(eventId))],
          //                 child: const EventDetailsPage()
          //               )
          //             );
          //           },
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
        ],
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) {
          return MaterialPage(child: HomePage());
        },
      ),
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) {
          return const MaterialPage(child: ProfilePage());
        },
      ),
      GoRoute(
        path: '/',
        pageBuilder: (context, state) {
          return const MaterialPage(child: LoginPage());
        },
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) {
          return const MaterialPage(child: RegisterPage());
        },
      ),
    ],
    redirect: (context, state) {
      if (authState.isLoading || authState.hasError) return null;

      // case for if the user is signed in
      if (authState.valueOrNull != null) {
        // only redirect to '/home' fi the current location is the root ('/')
        if (state.location == '/') {
          return '/home';
        }
        // do not redirect if the user is navigation to another page
        return null;
      }
      // case for when the user isn't signed in
      else {
        // redirect to the login page or register page if there's no authenticated user
        if (state.location == '/' || state.location == '/register') {
          return state.location;
        } else {
          return '/';
        }
      }
    },
  );
});
