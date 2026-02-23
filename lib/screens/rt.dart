import 'package:flutter/material.dart';
import 'logout_sc.dart'; // Ensure this matches your filename

class RTScreen extends StatefulWidget {
  const RTScreen({super.key});

  @override
  State<RTScreen> createState() => _RTScreenState();
}

class _RTScreenState extends State<RTScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FFFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'RT Dashboard',
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
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF00695C),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFF52b788),
            tabs: const [
              Tab(text: 'Mess Bill Calculation'),
              Tab(text: 'Student Mess Bills'),
              Tab(text: 'Role Verification'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMessBillCalculationTab(),
                _buildStudentMessBillsTab(),
                _buildRoleVerificationTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 1. Mess Bill Calculation (View Only)
  Widget _buildMessBillCalculationTab() {
    const double dailyRate = 95.0;
    const int totalStudents = 150;
    const int presentStudents = 142;
    final double calculatedTotal = dailyRate * presentStudents;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: _buildViewCard(
        title: 'Mess Bill Calculation Overview',
        icon: Icons.calculate,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _billRow('Daily Mess Rate per Student', '₹$dailyRate'),
            _billRow('Total Students in Hostel', '$totalStudents'),
            _billRow('Present Students (Today)', '$presentStudents'),
            const Divider(height: 30),
            _billRow('Total Calculated Bill', '₹${calculatedTotal.toStringAsFixed(2)}',
                isBold: true),
            const SizedBox(height: 16),
            const Text(
              'Formula: Daily Rate × Present Students',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // 2. Mess Bill of Each Student (View Only List)
  Widget _buildStudentMessBillsTab() {
    final List<Map<String, dynamic>> studentBills = [
      {'name': 'Rahul Sharma', 'roll': 'IT201', 'presentDays': 28, 'bill': 2660.0},
      {'name': 'Priya Singh', 'roll': 'IT202', 'presentDays': 30, 'bill': 2850.0},
      {'name': 'Amit Kumar', 'roll': 'IT203', 'presentDays': 25, 'bill': 2375.0},
      {'name': 'Sneha Gupta', 'roll': 'IT204', 'presentDays': 31, 'bill': 2945.0},
      {'name': 'Vikash Yadav', 'roll': 'IT205', 'presentDays': 27, 'bill': 2565.0},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: _buildViewCard(
        title: 'Individual Student Mess Bills',
        icon: Icons.receipt_long,
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: studentBills.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final student = studentBills[index];
            return ListTile(
              title: Text(student['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('Roll No: ${student['roll']} • Present: ${student['presentDays']} days'),
              trailing: Text(
                '₹${student['bill']}',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF00695C)),
              ),
            );
          },
        ),
      ),
    );
  }

  // 3. Role Verification
  Widget _buildRoleVerificationTab() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            labelColor: Color(0xFF00695C),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF52b788),
            tabs: [
              Tab(text: 'Wing Secretary'),
              Tab(text: 'Mess Secretary'),
              Tab(text: 'Hostel Secretary'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildWingSecAdditionTab(),
                _buildSimpleAddForm('Mess Secretary'),
                _buildSimpleAddForm('Hostel Secretary'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWingSecAdditionTab() {
    final List<String> wingPositions = [
      'Ground Floor - Wing 1',
      'Ground Floor - Wing 2',
      '1st Floor - Wing 1',
      '1st Floor - Wing 2',
      '2nd Floor - Wing 1',
      '2nd Floor - Wing 2',
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: wingPositions.length,
      itemBuilder: (context, index) {
        final position = wingPositions[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ExpansionTile(
            title: Text(
              'Add $position Wing Secretary',
              style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1b4332)),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildTextField('Name'),
                    const SizedBox(height: 12),
                    _buildTextField('Email ID'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$position Wing Secretary added!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF52b788),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Add Wing Secretary'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSimpleAddForm(String role) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add $role',
            style:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1b4332)),
          ),
          const SizedBox(height: 20),
          _buildTextField('Name'),
          const SizedBox(height: 16),
          _buildTextField('Email ID'),
          const SizedBox(height: 32),
          Center(
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$role added!')));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF52b788),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Add $role'),
            ),
          ),
        ],
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

  Widget _buildTextField(String label) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF52b788)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _billRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: 16)),
        ],
      ),
    );
  }
}
