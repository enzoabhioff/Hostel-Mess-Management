import 'package:flutter/material.dart';

class HostelSecComplaintDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const HostelSecComplaintDetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final String currentStatus = data['status'] ?? "Submitted";

    return Scaffold(
      appBar: AppBar(title: const Text("Complaint Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Basic Info
              Text(
                "Category: ${data['category']}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text("Room: ${data['room']}"),
              const SizedBox(height: 16),

              const Text(
                "Message",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(data['message'] ?? ""),

              const SizedBox(height: 30),

              // 🔹 Status Tracker
              const Text(
                "Status Tracker",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),

              _step("Submitted", currentStatus),
              _step("Hostel Secretary", currentStatus),
              _step("Matron", currentStatus),
              _step("RT", currentStatus),
              _step("Warden", currentStatus),
              _step("Office Admin", currentStatus),

              const SizedBox(height: 30),

              // 🔹 Forward Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Forwarded to Matron")),
                    );
                  },
                  child: const Text("Forward to Matron"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _step(String title, String currentStatus) {
    final bool done = title == currentStatus;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            done ? Icons.radio_button_checked : Icons.radio_button_unchecked,
            color: done ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: done ? FontWeight.bold : FontWeight.normal,
              color: done ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
