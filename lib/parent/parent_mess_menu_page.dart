import 'package:flutter/material.dart';

class ParentMessMenuPage extends StatelessWidget {
  const ParentMessMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mess Menu")),
      body: const Center(
        child: Text(
          "Mess Menu Page\n(Menu integration coming next)",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
