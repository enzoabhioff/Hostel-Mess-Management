import 'package:flutter/material.dart';

class ParentMessBillPage extends StatelessWidget {
  const ParentMessBillPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mess Bill")),
      body: const Center(
        child: Text(
          "Mess Bill Page\n(Bill integration coming next)",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
