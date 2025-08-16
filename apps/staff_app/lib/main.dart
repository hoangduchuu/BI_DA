import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  runApp(const App());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bida Staff App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.sports_bar,
                    color: Colors.white,
                    size: 40,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Bida Staff App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Billiard Club Management',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.table_bar),
              title: const Text('Table Management'),
              onTap: () {
                // TODO: Navigate to table management
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Bookings'),
              onTap: () {
                // TODO: Navigate to bookings
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant_menu),
              title: const Text('Orders'),
              onTap: () {
                // TODO: Navigate to orders
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt),
              title: const Text('Billing'),
              onTap: () {
                // TODO: Navigate to billing
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.card_giftcard),
              title: const Text('Loyalty'),
              onTap: () {
                // TODO: Navigate to loyalty
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // TODO: Navigate to settings
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_bar,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to Bida Staff App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Billiard Club Management System',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Features Coming Soon:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Text('• Table Management'),
            Text('• Booking System'),
            Text('• Order Processing'),
            Text('• Billing & Payment'),
            Text('• Loyalty Program'),
          ],
        ),
      ),
    );
  }
}
