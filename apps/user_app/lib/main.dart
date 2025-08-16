import 'package:flutter/material.dart';

void main() {
  runApp(const BidaUserApp());
}

class BidaUserApp extends StatelessWidget {
  const BidaUserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bida User App',
      theme: ThemeData(
        primarySwatch: Colors.green,
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
        title: const Text('Bida User App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_bar,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to Bida User App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Book Your Billiard Table',
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
            Text('• Table Booking'),
            Text('• View Available Tables'),
            Text('• Loyalty Points'),
            Text('• Payment History'),
            Text('• Special Offers'),
          ],
        ),
      ),
    );
  }
}
