
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'admin.dart';
import 'princi.dart';
import 'warden.dart';
import 'rt.dart';
import 'matron.dart';
import 'hossec.dart';
import 'messec.dart';
import 'pm.dart';
import 'wingsec.dart';
import 'std.dart';
import 'parent.dart';
import 'pm_otp_screen.dart';
import 'purchase.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    setState(() => _loading = true);

    try {
      final email = _emailController.text.trim().toLowerCase();

      // Special case: Purchase Manager OTP flow
      if (email == 'purchase@manager.com') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PMSOtpScreen()),
        );
        return;
      }

      // Normal Firebase login
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: _passwordController.text.trim(),
      );

      final uid = cred.user!.uid;
      debugPrint('USER UID: $uid');

      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!doc.exists) {
        throw Exception('User role not assigned in Firestore');
      }

      final role = (doc['role'] as String?)?.trim().toUpperCase() ?? '';

      debugPrint('USER ROLE: $role');

      Widget screen;

      switch (role) {
        case 'ADMIN':
          screen = const AdminScreen();
          break;
        case 'PRINCIPAL':
          screen = const PrincipalScreen();
          break;
        case 'WARDEN':
          screen = const WardenScreen();
          break;
        case 'RT':
          screen = const RTScreen();
          break;
        case 'MATRON':
          screen = const MatronScreen();
          break;
        case 'HOSTEL_SEC':
          screen = const HosSecScreen();
          break;
        case 'MESSSEC':
        case 'MESS_SEC':
          screen = const MessSecScreen();
          break;
        case 'WING_SEC':
          screen = const WingSecScreen();
          break;
        case 'STUDENT':
          screen = const StudentScreen();
          break;
        case 'PARENT':
          screen = const ParentScreen();
          break;
        case 'PURCHASE MANAGER':
        case 'PURCHASE_MANAGER':
          screen = const PurchaseManagerScreen();
          break;
        default:
          throw Exception('Invalid role: $role');
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => screen),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Login failed'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // ← important for keyboard
      backgroundColor: const Color(0xFFF5FFFB),
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: const Color(0xFF2d6a4f),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Logo / Icon
              Icon(
                Icons.account_circle,
                size: 100,
                color: const Color(0xFF40916c),
              ),

              const SizedBox(height: 32),

              // Email field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email, color: Color(0xFF40916c)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2d6a4f), width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Password field
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF40916c)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xFF40916c),
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2d6a4f), width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _loading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF40916c),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  child: _loading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                        )
                      : const Text(
                          'Login',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // Optional links (uncomment if needed)
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     TextButton(
              //       onPressed: () {
              //         // Forgot password
              //       },
              //       child: const Text('Forgot Password?', style: TextStyle(color: Color(0xFF2d6a4f))),
              //     ),
              //     TextButton(
              //       onPressed: () {
              //         // Sign up
              //       },
              //       child: const Text('Create Account', style: TextStyle(color: Color(0xFF2d6a4f))),
              //     ),
              //   ],
              // ),

              const SizedBox(height: 40),
            ],
          ),
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
