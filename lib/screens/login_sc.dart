// lib/screens/login_sc.dart
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final String role; // Displayed role (e.g., "Wing Secretary")
  final VoidCallback onLoginSuccess; // Called on successful login

  const LoginScreen({
    super.key,
    required this.role,
    required this.onLoginSuccess,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Fake credentials - replace with real Firebase Auth later
  final Map<String, Map<String, String>> fakeUsers = {
    'admin@hostel.com': {'password': 'admin123', 'role': 'ADMIN'},
    'principal@hostel.com': {'password': 'principal123', 'role': 'PRINCIPAL'},
    'warden@hostel.com': {'password': 'warden123', 'role': 'WARDEN'},
    'rt@hostel.com': {'password': 'rt123', 'role': 'RT'},
    'matron@hostel.com': {'password': 'matron123', 'role': 'MATRON'},
    'hostel.sec@hostel.com': {'password': 'hossec123', 'role': 'HOSTEL_SEC'},
    'mess.sec@hostel.com': {'password': 'mess123', 'role': 'MESS_SEC'},
    'purchase@hostel.com': {'password': 'purchase123', 'role': 'PURCHASE_MANAGER'},
    'wing.sec@hostel.com': {'password': 'wing123', 'role': 'WING_SEC'},
    'student@hostel.com': {'password': 'student123', 'role': 'STUDENT'},
    'parent@hostel.com': {'password': 'parent123', 'role': 'PARENT'},
  };

  void _login() {
    String email = _emailController.text.trim().toLowerCase();
    String password = _passwordController.text;

    final userData = fakeUsers[email];

    if (userData != null && userData['password'] == password) {
      // Success - call the callback so main.dart can navigate based on roleKey
      widget.onLoginSuccess();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Generate hint based on role
    String hintEmail = '';
    switch (widget.role) {
      case 'Admin':
        hintEmail = 'admin@hostel.com';
        break;
      case 'Principal':
        hintEmail = 'principal@hostel.com';
        break;
      case 'Warden':
        hintEmail = 'warden@hostel.com';
        break;
      case 'RT':
        hintEmail = 'rt@hostel.com';
        break;
      case 'Matron':
        hintEmail = 'matron@hostel.com';
        break;
      case 'Hostel Secretary':
        hintEmail = 'hostel.sec@hostel.com';
        break;
      case 'Mess Secretary':
        hintEmail = 'mess.sec@hostel.com';
        break;
      case 'Purchase Manager':
        hintEmail = 'purchase@hostel.com';
        break;
      case 'Wing Secretary':
        hintEmail = 'wing.sec@hostel.com';
        break;
      case 'Student':
        hintEmail = 'student@hostel.com';
        break;
      case 'Parent':
        hintEmail = 'parent@hostel.com';
        break;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5FFFB),
      appBar: AppBar(
        title: Text('${widget.role} Login'),
        backgroundColor: const Color(0xFF2d6a4f),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle, size: 100, color: Color(0xFF40916c)),
            const SizedBox(height: 32),
            Text(
              'Welcome, ${widget.role}',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1b4332)),
            ),
            const SizedBox(height: 8),
            Text(
              'Hint: $hintEmail',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Address',
                hintText: hintEmail,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF40916c),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Login', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}