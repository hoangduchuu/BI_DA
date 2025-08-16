import 'package:flutter/material.dart';

void main() {
  runApp(const BidaStaffApp());
}

class BidaStaffApp extends StatelessWidget {
  const BidaStaffApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bida Staff App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
        title: const Text('Bida Staff App'),
      ),
      body: const Center(
        child: Text('Welcome to Bida Staff App'),
      ),
    );
  }
}
