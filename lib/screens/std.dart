import 'package:flutter/material.dart';
import 'logout_sc.dart'; // Ensure this matches your filename

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  // Sample static data
  final String studentName = "Sahala";
  final int totalDaysInMonth = 31;
  final int presentDays = 27;
  final double dailyMessRate = 95.0;
  final double currentMessBill = 2565.0;

  final List<Map<String, String>> weeklyMenu = const [
    {'day': 'Monday', 'breakfast': 'Idli + Sambhar', 'lunch': 'Rice, Dal, Aloo Sabzi', 'dinner': 'Roti, Paneer Butter Masala'},
    {'day': 'Tuesday', 'breakfast': 'Poha + Tea', 'lunch': 'Jeera Rice, Rajma, Salad', 'dinner': 'Paratha, Egg Curry (NV)'},
    {'day': 'Wednesday', 'breakfast': 'Bread Toast + Jam', 'lunch': 'Khichdi, Kadhi, Papadam', 'dinner': 'Chapati, Chicken Curry (NV)'},
    {'day': 'Thursday', 'breakfast': 'Upma', 'lunch': 'Veg Pulao, Raita', 'dinner': 'Dosa + Chutney'},
    {'day': 'Friday', 'breakfast': 'Aloo Paratha', 'lunch': 'Biryani (Veg/Chicken)', 'dinner': 'Fried Rice + Chilli Paneer'},
    {'day': 'Saturday', 'breakfast': 'Puri Bhaji', 'lunch': 'Special Thali', 'dinner': 'Pav Bhaji'},
    {'day': 'Sunday', 'breakfast': 'Cornflakes + Fruits', 'lunch': 'North Indian Meal', 'dinner': 'Pizza / Pasta Night'},
  ];

  final List<String> messDuties = const [
    "Table Cleaning - After Dinner (Group B)",
    "Serving Assistance - Sunday Lunch",
    "Waste Segregation - Week 2",
  ];

  // ─── Complaint Section Data ─────────────────────────────────────────────────
  final _complaintTitleController = TextEditingController();
  final _complaintDescController = TextEditingController();
  final List<Map<String, String>> _myComplaints = [
    {'title': 'Food too spicy', 'date': 'Yesterday', 'status': 'Pending'},
    {'title': 'No salt in dal', 'date': '2 days ago', 'status': 'Resolved'},
  ];

  @override
  void dispose() {
    _complaintTitleController.dispose();
    _complaintDescController.dispose();
    super.dispose();
  }

  void _submitComplaint() {
    final title = _complaintTitleController.text.trim();
    final desc = _complaintDescController.text.trim();

    if (title.isEmpty || desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill title and description'), backgroundColor: Colors.red),
      );
      return;
    }

    // Add to local list (you can later save to Firestore)
    setState(() {
      _myComplaints.insert(0, {
        'title': title,
        'date': 'Just now',
        'status': 'Pending',
      });
    });

    _complaintTitleController.clear();
    _complaintDescController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Complaint submitted successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double attendancePercentage = (presentDays / totalDaysInMonth) * 100;
    double calculatedBill = dailyMessRate * presentDays;

    return Scaffold(
      backgroundColor: const Color(0xFFF5FFFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Student Dashboard',
          style: TextStyle(
            color: Color(0xFF2d6a4f),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
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
            // Welcome Section
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back,',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    studentName,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Attendance Card
            _buildInfoCard(
              title: "Your Attendance",
              icon: Icons.how_to_reg,
              child: Column(
                children: [
                  Text(
                    '$presentDays out of $totalDaysInMonth days',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF00695C)),
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: attendancePercentage / 100,
                    backgroundColor: Colors.grey[200],
                    color: attendancePercentage >= 75 ? Colors.green : Colors.orange,
                    minHeight: 12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${attendancePercentage.toStringAsFixed(1)}%',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Mess Bill
            _buildInfoCard(
              title: "Mess Bill",
              icon: Icons.receipt_long,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Current Bill Amount', style: TextStyle(fontSize: 18)),
                      Text(
                        '₹$currentMessBill',
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF00695C)),
                      ),
                    ],
                  ),
                  const Divider(height: 30),
                  const Text('Bill Calculation Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  _billDetailRow('Daily Rate', '₹$dailyMessRate'),
                  _billDetailRow('Days Present', '$presentDays days'),
                  _billDetailRow('Calculated Amount', '₹${calculatedBill.toStringAsFixed(2)}'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Weekly Food Menu
            _buildInfoCard(
              title: "Weekly Food Menu",
              icon: Icons.restaurant_menu,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: weeklyMenu.length,
                separatorBuilder: (_, __) => const Divider(height: 20),
                itemBuilder: (context, index) {
                  final day = weeklyMenu[index];
                  return ExpansionTile(
                    title: Text(day['day']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    children: [
                      _menuRow('Breakfast', day['breakfast']!),
                      _menuRow('Lunch', day['lunch']!),
                      _menuRow('Dinner', day['dinner']!),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Mess Duty
            _buildInfoCard(
              title: "Your Mess Duty",
              icon: Icons.assignment_turned_in,
              child: Column(
                children: messDuties.map((duty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Color(0xFF52b788), size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            duty,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 30),

            // ─── NEW: Complaint Section ────────────────────────────────────────────────
            _buildInfoCard(
              title: "Raise a Complaint",
              icon: Icons.report_problem,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Form to add new complaint
                  TextFormField(
                    controller: _complaintTitleController,
                    decoration: InputDecoration(
                      labelText: 'Complaint Title',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _complaintDescController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.send),
                      label: const Text('Submit Complaint'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _submitComplaint,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // List of previous complaints
                  const Text(
                    'Your Previous Complaints',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  if (_myComplaints.isEmpty)
                    const Text('No complaints submitted yet', style: TextStyle(color: Colors.grey))
                  else
                    ..._myComplaints.map((c) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const Icon(Icons.report, color: Colors.orange),
                            title: Text(c['title']!),
                            subtitle: Text('Submitted: ${c['date']} • Status: ${c['status']}'),
                            trailing: Chip(
                              label: Text(c['status']!),
                              backgroundColor: c['status'] == 'Pending' ? Colors.orange.shade100 : Colors.green.shade100,
                            ),
                          ),
                        )),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ─── Helper Methods (unchanged) ─────────────────────────────────────────────
  Widget _buildInfoCard({required String title, required IconData icon, required Widget child}) {
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
              Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1b4332))),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _billDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: valueColor)),
        ],
      ),
    );
  }

  Widget _menuRow(String meal, String items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(meal, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          const Text(': '),
          Expanded(child: Text(items)),
        ],
      ),
    );
  }
}
