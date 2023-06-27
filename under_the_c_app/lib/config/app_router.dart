import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:under_the_c_app/components/common/base_layout.dart';
import 'package:under_the_c_app/components/events/book_ticket.dart';
import 'package:under_the_c_app/components/events/event_details.dart';
import 'package:under_the_c_app/main.dart';
import 'package:under_the_c_app/pages/main_pages/analytics.dart';
import 'package:under_the_c_app/pages/main_pages/event.dart';
import 'package:under_the_c_app/pages/main_pages/home.dart';
import 'package:under_the_c_app/pages/main_pages/profile.dart';
import 'package:under_the_c_app/pages/main_pages/register.dart';

import '../pages/login_page.dart';
import 'auth_state_provider.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: "shellNavigator");

final Map<String, String> pageTitleMap = {
  '/home': 'Home',
  '/analytics': 'Analytics',
  '/events': 'Events',
  '/profile': 'Profile',
  '/event_details/:id': 'Event Details',
  '/event_booking/:id': 'Event Booking',
};

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
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
      ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return BaseLayout(
                body: child,
                title: state.extra != null ? state.extra!.toString() : "");
          },
          routes: <RouteBase>[
            GoRoute(
              path: '/analytics',
              pageBuilder: (context, state) {
                return const MaterialPage(child: AnalyticsPage());
              },
            ),
            GoRoute(
              path: '/events',
              pageBuilder: (context, state) {
                return const MaterialPage(child: EventPage());
              },
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
              path: '/event_details/:id',
              pageBuilder: (context, state) {
                final eventId = state.pathParameters['id'].toString();
                return MaterialPage(child: EventDetailsPage(eventId: eventId));
              },
            ),
            GoRoute(
                path: '/event_booking/:id',
                pageBuilder: (context, state) {
                  final eventId = state.pathParameters['id'].toString();
                  return MaterialPage(child: BookTicket(eventId: eventId));
                }),
          ]),
    ],
    redirect: (context, state) {
      if (authState.isLoading || authState.hasError) return null;

      // case for if the user is signed in
      if (authState.valueOrNull != null) {
        // only redirect to '/home' fi the current location is the root ('/')
        if (state.location == '/' && sessionIsHost) {
          return '/home';
        } else if (state.location == '/' && !sessionIsHost) {
          return '/profile';
        }

        // TODO: [PLHV-156] app_router.dart: 'sessionIsHost' is null before returning to /homeHost
        // if (state.location == '/home' && sessionIsHost!) {
        //   return '/homeHost';
        // }
        // do not redirect if the user is navigation to another page
        return null;
      }
      // case for when the user isn't signed in
      else {
        // redirect to the login page or register page if there's no authenticated user
        if (state.location == '/' ||
            state.location == '/register' ||
            state.location == '/reset' ||
            state.location.startsWith('/guest')) {
          return state.location;
        } else {
          return '/';
        }
      }
    },
  );
});
