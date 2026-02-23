import 'package:flutter/material.dart';
import 'otp_store.dart';
import 'pm.dart';

class PMSOtpScreen extends StatefulWidget {
  const PMSOtpScreen({super.key});

  @override
  State<PMSOtpScreen> createState() => _PMSOtpScreenState();
}

class _PMSOtpScreenState extends State<PMSOtpScreen> {
  final _otpController = TextEditingController();

  void _verifyOtp() {
    final enteredOtp = _otpController.text.trim();
    if (OTPStore.verifyOtp(enteredOtp)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PMScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect OTP'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PM OTP Login')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter OTP',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyOtp,
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
