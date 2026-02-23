import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_sc.dart'; // Login screen

class LogoutHandler {
  static void logout(BuildContext context) {
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
          TextButton(
            onPressed: () async {
              // 🔐 Sign out from Firebase
              await FirebaseAuth.instance.signOut();

              // 🔁 Go back to Login screen & clear stack
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
