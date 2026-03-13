import 'package:flutter/material.dart';

class OthersTabScreen extends StatelessWidget {
  const OthersTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Others")),
      body: const Center(child: Text("Other features coming soon")),
    );
  }
}
