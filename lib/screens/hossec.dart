import 'package:flutter/material.dart';
import 'logout_sc.dart'; // Ensure this matches your logout filename

class HosSecScreen extends StatelessWidget {
  const HosSecScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hostel Secretary Dashboard'),
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
          'Welcome, Hostel Secretary!\n\nStudent representative panel.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, color: Colors.black54),
        ),
      ),
    );
  }
}