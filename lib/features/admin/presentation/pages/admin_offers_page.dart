import 'package:flutter/material.dart';

class AdminOffersPage extends StatelessWidget {
  const AdminOffersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: const Center(
        child: Text('Offers Management - Demo UI'),
      ),
    );
  }
}