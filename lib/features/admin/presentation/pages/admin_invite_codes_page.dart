import 'package:flutter/material.dart';

class AdminInviteCodesPage extends StatelessWidget {
  const AdminInviteCodesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite Codes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: const Center(
        child: Text('Invite Codes Management - Demo UI'),
      ),
    );
  }
}