import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'core/di/dependency_injection.dart';
import 'features/auth/auth_provider.dart';
import 'features/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection with centralized API config
  await DependencyInjection.initialize();

  runApp(const BidaUserApp());
}

class BidaUserApp extends StatelessWidget {
  const BidaUserApp({super.key});

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
            title: 'Bida User App',
            theme: ThemeData(
              primarySwatch: Colors.green,
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.green,
                brightness: Brightness.light,
              ),
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.green,
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.green,
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
    ],
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Show loading screen while checking auth
        if (authProvider.state == AuthState.loading || authProvider.state == AuthState.initial) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final user = authProvider.user;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Bida User App'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              PopupMenuButton<String>(
                itemBuilder: (context) => [
                  PopupMenuItem<String>(
                    value: 'profile',
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(user?.username ?? 'Unknown'),
                      subtitle: Text(user?.role ?? 'No role'),
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: const ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'logout') {
                    _handleLogout(context, authProvider);
                  }
                },
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.green,
                  ),
                  accountName: Text(
                    '${user?.firstName ?? 'Unknown'} ${user?.lastName ?? 'User'}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  accountEmail: Text(user?.email ?? 'No email'),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      user?.firstName?.substring(0, 1).toUpperCase() ?? 'U',
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.table_restaurant),
                  title: const Text('Find Tables'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Feature coming soon!')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_month),
                  title: const Text('My Bookings'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Feature coming soon!')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.star),
                  title: const Text('Loyalty Points'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Feature coming soon!')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('History'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Feature coming soon!')),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Feature coming soon!')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Logout', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    _handleLogout(context, authProvider);
                  },
                ),
              ],
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 100,
                  color: Colors.green,
                ),
                const SizedBox(height: 20),
                Text(
                  'Welcome, ${user?.firstName ?? 'User'}!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    user?.role.toUpperCase() ?? 'ROLE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Billiard Club Customer App',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),
                const Text('✅ Authentication & Login'),
                const Text('✅ User Profile'),
                const Text('✅ JWT Token Storage'),
                const SizedBox(height: 20),
                const Text('🚧 Table Booking'),
                const Text('🚧 Loyalty Points'),
                const Text('🚧 Order History'),
                const Text('🚧 Notifications'),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleLogout(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await authProvider.logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
