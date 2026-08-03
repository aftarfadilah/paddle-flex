import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/presentation/sign_in_screen.dart';
import '../../features/feed/presentation/feed_screen.dart';
import '../../features/leaderboard/presentation/board_screen.dart';
import '../../features/log_session/presentation/log_session_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/leaderboard/presentation/rank_screen.dart';
import '../../features/home/presentation/home_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => const SignInScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => HomeShell(
        child: child,
        location: state.uri.path,
      ),
      routes: [
        GoRoute(
          path: '/feed',
          pageBuilder: (context, state) => const NoTransitionPage(child: FeedScreen()),
        ),
        GoRoute(
          path: '/board',
          pageBuilder: (context, state) => const NoTransitionPage(child: BoardScreen()),
        ),
        GoRoute(
          path: '/log',
          pageBuilder: (context, state) => const NoTransitionPage(child: LogSessionScreen()),
        ),
        GoRoute(
          path: '/rank',
          pageBuilder: (context, state) => const NoTransitionPage(child: RankScreen()),
        ),
        GoRoute(
          path: '/profile/:userId',
          pageBuilder: (context, state) => NoTransitionPage(
            child: ProfileScreen(userId: state.pathParameters['userId'] ?? 'me'),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/',
      redirect: (_, __) => '/feed',
    ),
  ],
);
