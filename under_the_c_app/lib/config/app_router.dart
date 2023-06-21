import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../login_page.dart';
import '../main.dart';

class AppRouter {
  GoRouter router = GoRouter(routes: [
    GoRoute(
        path: '/home',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: RootPage(),
          );
        }),
    GoRoute(
        path: '/',
        pageBuilder: (context, state) {
          return MaterialPage(
            child: LoginPage(),
          );
        })
  ]);
}
