import 'package:flutter/material.dart';

void main() {
  runApp(const BidaAdminWebApp());
}

class BidaAdminWebApp extends StatelessWidget {
  const BidaAdminWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bida Admin Web',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bida Admin Web'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.admin_panel_settings,
              size: 100,
              color: Colors.indigo,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to Bida Admin Web',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Club Management Dashboard',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Admin Features Coming Soon:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Text('• Club Management'),
            Text('• Staff Management'),
            Text('• Revenue Reports'),
            Text('• Table Analytics'),
            Text('• System Settings'),
          ],
        ),
      ),
    );
  }
}
