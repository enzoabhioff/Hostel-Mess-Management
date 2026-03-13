import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../student/student_data.dart';

class ParentAttendancePage extends StatelessWidget {
  const ParentAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final admissionNo = StudentData.admissionNo;

    return Scaffold(
      appBar: AppBar(title: const Text("Student Attendance")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('attendance').snapshots(),
        builder: (context, monthSnapshot) {
          if (!monthSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final months = monthSnapshot.data!.docs;

          if (months.isEmpty) {
            return const Center(child: Text("No attendance records"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: months.length,
            itemBuilder: (context, index) {
              final monthId = months[index].id;

              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('attendance')
                    .doc(monthId)
                    .collection('records')
                    .doc(admissionNo)
                    .snapshots(),
                builder: (context, recordSnap) {
                  if (!recordSnap.hasData || !recordSnap.data!.exists) {
                    return const SizedBox();
                  }

                  final data = recordSnap.data!.data() as Map<String, dynamic>;

                  final int present = data['present'] ?? 0;
                  final int total = data['total'] ?? 0;
                  final int absent = total - present;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Month: $monthId",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text("Name: ${StudentData.name}"),
                          Text("Room: ${StudentData.room}"),
                          const SizedBox(height: 10),
                          Text("Attendance: $present / $total"),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
