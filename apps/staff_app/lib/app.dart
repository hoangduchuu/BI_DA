import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'main.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
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
        routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    // TODO: Add more routes for features
    // GoRoute(
    //   path: '/auth',
    //   builder: (context, state) => const AuthPage(),
    // ),
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
