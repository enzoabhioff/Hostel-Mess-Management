import 'package:flutter/material.dart';
import 'logout_sc.dart'; // Ensure this matches your filename

class ParentScreen extends StatelessWidget {
  const ParentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Dashboard'),
        backgroundColor: const Color.fromARGB(255, 56, 230, 169),
        foregroundColor: Colors.white,
        centerTitle: true,
        // --- Added Logout Button ---
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => LogoutHandler.logout(context),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome, Parent!\n\nView updates & communicate.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, color: Colors.black54),
        ),
      ),
    );
  }
}