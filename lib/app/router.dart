import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/models/generated_component.dart';
import '../features/code_viewer/code_viewer_screen.dart';
import '../features/generator/generator_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/preview/preview_screen.dart';
import '../features/result/result_screen.dart';
import '../features/saved/saved_components_screen.dart';
import '../features/settings/settings_screen.dart';

class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'onboarding',
        pageBuilder: (context, state) => _page(state, const OnboardingScreen()),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        pageBuilder: (context, state) => _page(state, const GeneratorScreen()),
      ),
      GoRoute(
        path: '/result',
        name: 'result',
        pageBuilder: (context, state) {
          final component = state.extra is GeneratedComponent ? state.extra! as GeneratedComponent : null;
          return _page(state, ResultScreen(initialComponent: component));
        },
      ),
      GoRoute(
        path: '/preview',
        name: 'preview',
        pageBuilder: (context, state) {
          final component = state.extra is GeneratedComponent ? state.extra! as GeneratedComponent : null;
          return _page(state, PreviewScreen(component: component));
        },
      ),
      GoRoute(
        path: '/code',
        name: 'code',
        pageBuilder: (context, state) {
          final args = state.extra is CodeViewerArgs ? state.extra! as CodeViewerArgs : null;
          return _page(state, CodeViewerScreen(args: args));
        },
      ),
      GoRoute(
        path: '/saved',
        name: 'saved',
        pageBuilder: (context, state) => _page(state, const SavedComponentsScreen()),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        pageBuilder: (context, state) => _page(state, const SettingsScreen()),
      ),
    ],
  );

  static CustomTransitionPage<void> _page(GoRouterState state, Widget child) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 340),
      reverseTransitionDuration: const Duration(milliseconds: 260),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 0.035), end: Offset.zero).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}
