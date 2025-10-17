import 'package:flutter/material.dart';

class AdminTechniciansPage extends StatelessWidget {
  const AdminTechniciansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Technicians'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: const Center(
        child: Text('Technicians Management - Demo UI'),
      ),
    );
  }
}