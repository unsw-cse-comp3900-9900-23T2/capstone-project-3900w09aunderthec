import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:under_the_c_app/layout/base_layout.dart';
import 'package:under_the_c_app/components/ticket/book_ticket.dart';
import 'package:under_the_c_app/components/events/event_create/event_create.dart';
import 'package:under_the_c_app/components/events/event_details/event_details.dart';
import 'package:under_the_c_app/components/ticket/ticket_confirmation.dart';
import 'package:under_the_c_app/config/routes/routes.dart';
import 'package:under_the_c_app/config/session_variables.dart';
import 'package:under_the_c_app/pages/guest/guest_home.dart';
import 'package:under_the_c_app/pages/main/analytics.dart';
import 'package:under_the_c_app/pages/main/event.dart';
import 'package:under_the_c_app/pages/main/home.dart';
import 'package:under_the_c_app/pages/main/profile.dart';
import 'package:under_the_c_app/pages/main/auth/register.dart';
import 'package:under_the_c_app/pages/main/auth/reset.dart';
import '../../pages/main/auth/login/login_page.dart';
import '../auth_state_provider.dart';

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
          // TODO: [PLHV-204] App_router.dart: When the user login, it doesn't get stored to the db
          return const MaterialPage(child: LoginPage());
        },
      ),
      GoRoute(
        path: AppRoutes.register,
        pageBuilder: (context, state) {
          return const MaterialPage(child: RegisterPage());
        },
      ),
      GoRoute(
        path: AppRoutes.reset,
        pageBuilder: (context, state) {
          return const MaterialPage(child: ResetPasswordPage());
        },
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return BaseLayout(
              body: child,
              title: state.extra != null ? state.extra!.toString() : "",
              isHost: sessionVariables.sessionIsHost);
        },

        // TODO: [PLHV-201] Reset page needs to be different, we need to provide going back button and potential nav bar
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutes.reset,
            pageBuilder: (context, state) {
              return const MaterialPage(child: ResetPasswordPage());
            },
          ),
          GoRoute(
            path: AppRoutes.analytics,
            pageBuilder: (context, state) {
              return const MaterialPage(child: AnalyticsPage());
            },
          ),
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) {
              return const MaterialPage(child: HomePage());
            },
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (context, state) {
              return const MaterialPage(child: ProfilePage());
            },
          ),
          GoRoute(
            path: AppRoutes.guest,
            pageBuilder: (context, state) {
              return MaterialPage(child: GuestPage());
            },
          ),

          // events routes
          GoRoute(
            path: AppRoutes.events,
            pageBuilder: (context, state) {
              return MaterialPage(
                child: EventPage(isHost: sessionVariables.sessionIsHost),
              );
            },
          ),
          GoRoute(
            path: AppRoutes.eventDetails(':id'),
            pageBuilder: (context, state) {
              final eventId = state.pathParameters['id'].toString();
              return MaterialPage(child: EventDetailsPage(eventId: eventId));
            },
          ),
          GoRoute(
            path: AppRoutes.eventBook(':id'),
            pageBuilder: (context, state) {
              final eventId = state.pathParameters['id'].toString();
              return MaterialPage(child: BookTicket(eventId: eventId));
            },
          ),
          GoRoute(
            path: AppRoutes.eventAdd,
            pageBuilder: (context, state) {
              return const MaterialPage(child: EventCreate());
            },
          ),
          GoRoute(
            path: AppRoutes.ticketConfirmation,
            pageBuilder: (context, state) {
              return const MaterialPage(child: TicketConfirmation());
            },
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      if (authState.isLoading || authState.hasError) return null;

      // case for if the user is signed in
      if (authState.valueOrNull != null) {
        // only redirect to '/home' if the current location is the root ('/')
        if (state.location == '/') {
          return '/home';
        }
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