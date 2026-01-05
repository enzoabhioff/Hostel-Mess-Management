import 'package:flutter/material.dart';
import 'logout_sc.dart'; // Ensure this matches your filename

class PrincipalScreen extends StatelessWidget {
  const PrincipalScreen({super.key});

  // Sample student attendance data
  final List<Map<String, dynamic>> studentAttendance = const [
    {'name': 'NANDITHA ', 'present': true},
    {'name': 'TEENA', 'present': true},
    {'name': 'ANIKA', 'present': false},
    {'name': 'NAZRIN', 'present': true},
    {'name': 'HARSHA', 'present': true},
    {'name': 'NASHVA', 'present': true},
    {'name': 'SONA', 'present': false},
    {'name': 'ASHMIDA', 'present': true},
    {'name': 'SOJA', 'present': true},
    {'name': 'ADITHYA', 'present': true},
    {'name': 'GOPIKA', 'present': false},
    {'name': 'ADITHI', 'present': true},
    {'name': 'MALAVIKA', 'present': true},
    {'name': 'ANEESHYA', 'present': true},
    {'name': 'GANGA', 'present': false},
  ];

  final double dailyMessRate = 95.0;
  final double totalMessBill = 13500.0;

  final List<Map<String, String>> orderedList = const [
    {'item': 'Rice', 'quantity': '200 kg', 'date': 'Dec 1, 2025'},
    {'item': 'Dal', 'quantity': '80 kg', 'date': 'Dec 2, 2025'},
    {'item': 'Vegetables', 'quantity': '300 kg', 'date': 'Dec 5, 2025'},
    {'item': 'Milk', 'quantity': '500 liters', 'date': 'Dec 8, 2025'},
    {'item': 'Chicken (NV)', 'quantity': '100 kg', 'date': 'Dec 10, 2025'},
  ];

  final List<Map<String, String>> verifiedList = const [
    {'item': 'Rice', 'quantity': '200 kg', 'status': 'Verified', 'date': 'Dec 3, 2025'},
    {'item': 'Dal', 'quantity': '78 kg', 'status': 'Verified', 'date': 'Dec 4, 2025'},
    {'item': 'Vegetables', 'quantity': '295 kg', 'status': 'Verified', 'date': 'Dec 7, 2025'},
    {'item': 'Milk', 'quantity': '490 liters', 'status': 'Shortage', 'date': 'Dec 9, 2025'},
  ];

  @override
  Widget build(BuildContext context) {
    int presentCount = studentAttendance.where((s) => s['present']).length;
    double attendancePercent =
        studentAttendance.isEmpty ? 0 : (presentCount / studentAttendance.length) * 100;
    double calculatedBill = dailyMessRate * presentCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF5FFFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Principal Dashboard',
          style: TextStyle(
            color: Color(0xFF2d6a4f),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        // --- Added Logout Button ---
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF2d6a4f)),
            tooltip: 'Logout',
            onPressed: () => LogoutHandler.logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF95d5b2), Color(0xFF74c69d)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, Principal',
                    style:
                        TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Overview of mess operations and attendance',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 1. Attendance Overview
            _buildViewCard(
              title: 'Attendance Overview',
              icon: Icons.how_to_reg,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('$presentCount / ${studentAttendance.length} Present',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('${attendancePercent.toStringAsFixed(1)}%',
                          style: const TextStyle(fontSize: 20, color: Color(0xFF00695C))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: attendancePercent / 100,
                    backgroundColor: Colors.grey[200],
                    color: attendancePercent >= 90 ? Colors.green : Colors.orange,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(height: 16),
                  const Text('Student List',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: studentAttendance.length,
                      itemBuilder: (context, index) {
                        final student = studentAttendance[index];
                        bool isPresent = student['present'];
                        return ListTile(
                          leading: Icon(
                            isPresent ? Icons.check_circle : Icons.cancel,
                            color: isPresent ? Colors.green : Colors.red,
                          ),
                          title: Text(student['name']),
                          trailing: Text(
                            isPresent ? 'Present' : 'Absent',
                            style: TextStyle(color: isPresent ? Colors.green : Colors.red),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. Mess Bill Summary
            _buildViewCard(
              title: 'Mess Bill Summary',
              icon: Icons.receipt_long,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Estimated Bill', style: TextStyle(fontSize: 18)),
                      Text('₹$totalMessBill',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF00695C))),
                    ],
                  ),
                  const Divider(height: 30),
                  _billRow('Daily Rate per Student', '₹$dailyMessRate'),
                  _billRow('Present Students', '$presentCount'),
                  _billRow('Calculated Bill', '₹${calculatedBill.toStringAsFixed(2)}'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. Calculation Details
            _buildViewCard(
              title: 'Mess Bill Calculation',
              icon: Icons.calculate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Formula: Daily Rate × Present Students',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),
                  _billRow('Daily Rate', '₹$dailyMessRate'),
                  _billRow('Present Students', presentCount.toString()),
                  const Divider(),
                  _billRow('Total Calculated', '₹${calculatedBill.toStringAsFixed(2)}',
                      isBold: true),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. Ordered List
            _buildViewCard(
              title: 'Ordered List',
              icon: Icons.shopping_cart,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orderedList.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final item = orderedList[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title:
                        Text(item['item']!, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('Quantity: ${item['quantity']} • Ordered: ${item['date']}'),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // 5. Verified List
            _buildViewCard(
              title: 'Verified List',
              icon: Icons.verified,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: verifiedList.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final item = verifiedList[index];
                  bool isShort = item['status'] == 'Shortage';
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title:
                        Text(item['item']!, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('Received: ${item['quantity']} • ${item['date']}'),
                    trailing: Chip(
                      label: Text(item['status']!,
                          style: TextStyle(color: isShort ? Colors.red : Colors.green, fontSize: 12)),
                      backgroundColor: isShort ? Colors.red[50] : Colors.green[50],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildViewCard({required String title, required IconData icon, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),
            blurRadius: 15,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF40916c), size: 28),
              const SizedBox(width: 12),
              Text(title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1b4332))),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _billRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: 16)),
        ],
      ),
    );
  }
}