import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/onboarding/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/tasks/presentation/pages/home_page.dart';
import '../../features/tasks/presentation/pages/add_task_page.dart';
import '../../features/tasks/presentation/pages/edit_task_page.dart';
import '../../features/tasks/presentation/pages/task_detail_page.dart';
import '../../features/calendar/presentation/pages/calendar_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/main/presentation/pages/main_navigation_shell.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import 'go_router_refresh_stream.dart';

class AppRouter {
  static GoRouter router(BuildContext context) {
    final authBloc = context.read<AuthBloc>();

    return GoRouter(
      initialLocation: '/',
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        final authState = authBloc.state;
        final isAuth = authState is AuthAuthenticated;
        final isLoggingIn = state.matchedLocation == '/login' ||
                            state.matchedLocation == '/register' ||
                            state.matchedLocation == '/forgot-password';
        final isSplash = state.matchedLocation == '/' || state.matchedLocation == '/onboarding';

        if (isSplash) return null; // Let splash handle onboarding routing

        if (!isAuth && !isLoggingIn) {
          return '/login'; // Unauthenticated trying to access protected route
        }

        if (isAuth && isLoggingIn) {
          return '/home'; // Authenticated trying to access login
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (context, state) => const ForgotPasswordPage(),
        ),
        // Main shell with bottom navigation
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainNavigationShell(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home',
                  builder: (context, state) => const HomePage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/calendar',
                  builder: (context, state) => const CalendarPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/profile',
                  builder: (context, state) => const ProfilePage(),
                ),
              ],
            ),
          ],
        ),
        // Task detail routes (outside shell, pushed on top)
        GoRoute(
          path: '/add-task',
          builder: (context, state) => AddTaskPage(
            initialDate: state.extra as DateTime?,
          ),
        ),
        GoRoute(
          path: '/edit-task',
          builder: (context, state) => EditTaskPage(
            task: state.extra as dynamic,
          ),
        ),
        GoRoute(
          path: '/task-detail',
          builder: (context, state) => TaskDetailPage(
            task: state.extra as dynamic,
          ),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    );
  }
}
