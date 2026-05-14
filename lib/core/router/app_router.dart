// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uni_connect/core/widgets/app_shell.dart';
import 'package:uni_connect/features/home/screens/home_screen.dart';
import 'package:uni_connect/features/events/screens/events_screen.dart';
import 'package:uni_connect/features/timer/screens/timer_screen.dart';
import 'package:uni_connect/features/budget/screens/budget_screen.dart';
import 'package:uni_connect/features/clubs/screens/clubs_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(path: '/home', builder: (c, s) => const HomeScreen()),
          GoRoute(path: '/events', builder: (c, s) => const EventsScreen()),
          GoRoute(path: '/timer', builder: (c, s) => const TimerScreen()),
          GoRoute(path: '/budget', builder: (c, s) => const BudgetScreen()),
          GoRoute(path: '/clubs', builder: (c, s) => const ClubsScreen()),
        ],
      ),
    ],
  );
});
