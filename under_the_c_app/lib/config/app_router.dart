import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../login_page.dart';
import '../main.dart';
import 'auth_state_provider.dart';

class AppRouter {
  final authState = ref.watch(authProvider);
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
        }),
  ], redirect: (context, state) {});
}
