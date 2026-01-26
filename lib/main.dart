// lib/main.dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';   // ✅ REQUIRED

import 'screens/login_sc.dart';
import 'screens/std.dart';
import 'screens/admin.dart';
import 'screens/princi.dart';
import 'screens/warden.dart';
import 'screens/rt.dart';
import 'screens/matron.dart';
import 'screens/hossec.dart';
import 'screens/messec.dart';
import 'screens/pm.dart';
import 'screens/wingsec.dart';
import 'screens/parent.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // ✅ REQUIRED
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HostelDashboard(),
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFF5FFFB)),
    );
  }
}

class HostelDashboard extends StatelessWidget {
  const HostelDashboard({super.key});

  final List<Map<String, dynamic>> roles = const [
    {'letter': 'A', 'title': 'Admin', 'roleKey': 'ADMIN'},
    {'letter': 'P', 'title': 'Principal', 'roleKey': 'PRINCIPAL'},
    {'letter': 'W', 'title': 'Warden', 'roleKey': 'WARDEN'},
    {'letter': 'R', 'title': 'RT', 'roleKey': 'RT'},
    {'letter': 'M', 'title': 'Matron', 'roleKey': 'MATRON'},
    {'letter': 'H', 'title': 'Hostel Sec', 'roleKey': 'HOSTEL_SEC'},
    {'letter': 'M', 'title': 'Mess Sec', 'roleKey': 'MESS_SEC'},
    {'letter': 'P', 'title': 'Purchase', 'roleKey': 'PURCHASE_MANAGER'},
    {'letter': 'W', 'title': 'Wing Sec', 'roleKey': 'WING_SEC'},
    {'letter': 'S', 'title': 'Student', 'roleKey': 'STUDENT'},
    {'letter': 'P', 'title': 'Parent', 'roleKey': 'PARENT'},
  ];

  Widget _getScreenForRole(String roleKey) {
    switch (roleKey) {
      case 'ADMIN':
        return const AdminScreen();
      case 'PRINCIPAL':
        return const PrincipalScreen();
      case 'WARDEN':
        return const WardenScreen();
      case 'RT':
        return const RTScreen();
      case 'MATRON':
        return const MatronScreen();
      case 'HOSTEL_SEC':
        return const HosSecScreen();
      case 'MESS_SEC':
        return MessSecScreen();
      case 'PURCHASE_MANAGER':
        return PMScreen();
      case 'WING_SEC':
        return WingSecScreen();
      case 'STUDENT':
        return const StudentScreen();
      case 'PARENT':
        return ParentScreen();
      default:
        return const Scaffold(body: Center(child: Text('Role not found')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FFFB),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 40, bottom: 20),
              child: Text(
                'Hostel Mess',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2d6a4f)),
              ),
            ),
            const Text('Select your role to continue', style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 60),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: roles.sublist(0, 4).map((role) => _buildRoleCard(role, context)).toList(),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: roles.sublist(4, 8).map((role) => _buildRoleCard(role, context)).toList(),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: roles.sublist(8, 11).map((role) => _buildRoleCard(role, context)).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard(Map<String, dynamic> role, BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(
                role: role['title'],
                onLoginSuccess: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => _getScreenForRole(role['roleKey'])),
                  );
                },
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 15, offset: const Offset(0, 8)),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(color: Color(0xFFB2DFDB), shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    role['letter'],
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF00695C)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                role['title'],
                style: const TextStyle(fontSize: 14, color: Color(0xFF004D40)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
