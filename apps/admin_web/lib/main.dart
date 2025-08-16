import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:core_domain/core_domain.dart';
import 'core/di/dependency_injection.dart';
import 'features/auth/auth_provider.dart';
import 'features/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection
  await DependencyInjection.initialize(
    baseUrl: 'http://localhost:8080', // Backend API URL
  );
  
  runApp(const BidaAdminWebApp());
}

class BidaAdminWebApp extends StatelessWidget {
  const BidaAdminWebApp({super.key});

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
            title: 'Bida Admin Web',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.purple,
                brightness: Brightness.light,
              ),
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.purple,
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.purple,
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
        final isWideScreen = MediaQuery.of(context).size.width > 800;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Billiard Club Admin Dashboard'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: authProvider.refreshUser,
                tooltip: 'Refresh Data',
              ),
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.purple,
                        child: Text(
                          user?.firstName.substring(0, 1).toUpperCase() ?? 'A',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      if (isWideScreen) ...[
                        const SizedBox(width: 8),
                        Text(user?.username ?? 'Admin'),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          drawer: isWideScreen ? null : _buildDrawer(context, user, authProvider),
          body: Row(
            children: [
              if (isWideScreen) _buildSidebar(context, user, authProvider),
              Expanded(child: _buildMainContent(context, user)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context, User? user, AuthProvider authProvider) {
    return Drawer(
      child: _buildNavigation(context, user, authProvider),
    );
  }

  Widget _buildSidebar(BuildContext context, User? user, AuthProvider authProvider) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade300)),
      ),
      child: _buildNavigation(context, user, authProvider),
    );
  }

  Widget _buildNavigation(BuildContext context, User? user, AuthProvider authProvider) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          decoration: const BoxDecoration(color: Colors.purple),
          accountName: Text(
            '${user?.firstName ?? 'Unknown'} ${user?.lastName ?? 'Admin'}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          accountEmail: Text(user?.email ?? 'No email'),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              user?.firstName.substring(0, 1).toUpperCase() ?? 'A',
              style: const TextStyle(
                color: Colors.purple,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.dashboard),
          title: const Text('Dashboard'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ExpansionTile(
          leading: const Icon(Icons.business),
          title: const Text('Company Management'),
          children: [
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Company'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Feature coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Manage Companies'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Feature coming soon!')),
                );
              },
            ),
          ],
        ),
        ExpansionTile(
          leading: const Icon(Icons.people),
          title: const Text('User Management'),
          children: [
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Add User'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Feature coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.manage_accounts),
              title: const Text('Manage Users'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Feature coming soon!')),
                );
              },
            ),
          ],
        ),
        ListTile(
          leading: const Icon(Icons.analytics),
          title: const Text('Analytics'),
          onTap: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Feature coming soon!')),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('System Settings'),
          onTap: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Feature coming soon!')),
            );
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Logout', style: TextStyle(color: Colors.red)),
          onTap: () {
            Navigator.pop(context);
            _handleLogout(context, authProvider);
          },
        ),
      ],
    );
  }

  Widget _buildMainContent(BuildContext context, User? user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.admin_panel_settings, size: 32, color: Colors.purple),
              const SizedBox(width: 16),
              Text(
                'Welcome, ${user?.firstName ?? 'Admin'}!',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.purple.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              user?.role.toUpperCase() ?? 'ADMIN',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.purple.shade700,
              ),
            ),
          ),
          const SizedBox(height: 40),
          
          // Dashboard Cards
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 4 : 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildDashboardCard(
                'Authentication',
                '✅ Active',
                Icons.security,
                Colors.green,
              ),
              _buildDashboardCard(
                'API Integration',
                '✅ Connected',
                Icons.api,
                Colors.blue,
              ),
              _buildDashboardCard(
                'User Management',
                '🚧 Coming Soon',
                Icons.people,
                Colors.orange,
              ),
              _buildDashboardCard(
                'Analytics',
                '🚧 Coming Soon',
                Icons.analytics,
                Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 40),
          
          Text(
            'System Features',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey[800]),
          ),
          const SizedBox(height: 16),
          const Column(
            children: [
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text('✅ Multi-tenant Authentication'),
                subtitle: Text('JWT-based secure login system'),
              ),
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text('✅ Role-based Access Control'),
                subtitle: Text('Admin, Manager, Staff role hierarchy'),
              ),
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text('✅ Responsive Web Interface'),
                subtitle: Text('Desktop and tablet optimized'),
              ),
              ListTile(
                leading: Icon(Icons.construction, color: Colors.orange),
                title: Text('🚧 Company Management'),
                subtitle: Text('Multi-club enterprise management'),
              ),
              ListTile(
                leading: Icon(Icons.construction, color: Colors.orange),
                title: Text('🚧 Real-time Analytics'),
                subtitle: Text('Business intelligence dashboard'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(String title, String status, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              status,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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
