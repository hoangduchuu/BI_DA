import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'features/auth/auth_provider.dart';
import 'features/auth/login_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider()..initialize(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp.router(
            title: 'Bida Staff App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.light,
              ),
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ),
            ),
            routerConfig: _createRouter(authProvider),
          );
        },
      ),
    );
  }
}

GoRouter _createRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authProvider.isAuthenticated;
      final isLoggingIn = state.fullPath == '/login';

      // Show loading screen while checking auth status
      if (authProvider.state == AuthState.initial || authProvider.state == AuthState.loading) {
        return null; // Let the current route handle loading state
      }

      // If not logged in and not on login page, redirect to login
      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      // If logged in and on login page, redirect to home
      if (isLoggedIn && isLoggingIn) {
        return '/';
      }

      // No redirect needed
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      // TODO: Add more routes for features
      // GoRoute(
      //   path: '/tables',
      //   builder: (context, state) => const TablesPage(),
      // ),
      // GoRoute(
      //   path: '/bookings',
      //   builder: (context, state) => const BookingsPage(),
      // ),
      // GoRoute(
      //   path: '/orders',
      //   builder: (context, state) => const OrdersPage(),
      // ),
      // GoRoute(
      //   path: '/billing',
      //   builder: (context, state) => const BillingPage(),
      // ),
      // GoRoute(
      //   path: '/loyalty',
      //   builder: (context, state) => const LoyaltyPage(),
      // ),
    ],
  );
}
