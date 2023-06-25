import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/components/common/base_layout.dart';
import 'package:under_the_c_app/pages/event.dart';
import 'package:under_the_c_app/pages/home.dart';
import 'package:under_the_c_app/pages/profile.dart';

import '../login_page.dart';
import '../pages/analytics.dart';
import 'auth_state_provider.dart';

final _key = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _key,
    initialLocation: '/',
    routes: [
      GoRoute(
          path: '/analytics',
          pageBuilder: (context, state) {
            return const MaterialPage(child: BaseLayout(body: AnalyticsPage()));
          }),
      GoRoute(
          path: '/events',
          pageBuilder: (context, state) {
            return const MaterialPage(child: BaseLayout(body: EventPage()));
          }),
      GoRoute(
          path: '/home',
          pageBuilder: (context, state) {
            return MaterialPage(child: BaseLayout(body: HomePage()));
          }),
      GoRoute(
          path: '/profile',
          pageBuilder: (context, state) {
            return const MaterialPage(child: BaseLayout(body: ProfilePage()));
          }),
      GoRoute(
          path: '/',
          pageBuilder: (context, state) {
            return MaterialPage(
              child: LoginPage(),
            );
          }),
    ],
    redirect: (context, state) {
      if (authState.isLoading || authState.hasError) return null;
      if (authState.valueOrNull != null) {
        // only redirect to '/home' fi the current location is the root ('/')
        if (state.location == '/') {
          return '/home';
        }
        // do not redirect if the user is navigation to another page
        return null;
      } else {
        // redirect to the login page if there's no authentificated user
        return '/';
      }
    },
  );
});
