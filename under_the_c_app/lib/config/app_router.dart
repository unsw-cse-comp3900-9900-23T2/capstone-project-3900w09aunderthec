import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:under_the_c_app/components/common/base_layout.dart';

import '../login_page.dart';
import '../main.dart';
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
          path: '/home',
          pageBuilder: (context, state) {
            return const MaterialPage(child: BaseLayout(body: AnalyticsPage()));
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
        return '/home';
      } else {
        return '/';
      }
    },
  );
});
