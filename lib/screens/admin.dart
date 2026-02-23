import 'package:flutter/material.dart';
import 'logout_sc.dart'; // Ensure this matches your filename

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          'Admin Dashboard',
          style: TextStyle(
            color: Color(0xFF2d6a4f),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Added Logout Button
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF2d6a4f)),
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
              Tab(text: 'Roles Verification'),
              Tab(text: 'Mess Bill Verification'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRolesVerificationTab(),
                _buildMessBillVerificationTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRolesVerificationTab() {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          const TabBar(
            labelColor: Color(0xFF00695C),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF52b788),
            tabs: [
              Tab(text: 'Principal'),
              Tab(text: 'RT'),
              Tab(text: 'Matron'),
              Tab(text: 'Warden'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildAddUserForm('Principal'),
                _buildAddUserForm('RT'),
                _buildAddUserForm('Matron'),
                _buildAddUserForm('Warden'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddUserForm(String role) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add $role User',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1b4332)),
          ),
          const SizedBox(height: 20),
          _buildTextField('Name'),
          const SizedBox(height: 16),
          _buildTextField('Email ID'),
          const SizedBox(height: 16),
          _buildTextField('Login ID'),
          const SizedBox(height: 16),
          _buildTextField('Password', obscureText: true),
          const SizedBox(height: 32),
          Center(
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$role user added!')));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF52b788),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Add User'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessBillVerificationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOptionSection(
            title: '1. Ordered List',
            child: const Text('List of items ordered for mess (e.g., veggies, groceries). View or verify here.'),
          ),
          const SizedBox(height: 20),
          _buildOptionSection(
            title: '2. Received List',
            child: const Text('List of items received. Compare with ordered list.'),
          ),
          const SizedBox(height: 20),
          _buildOptionSection(
            title: '3. Mess Bill Calculation',
            child: const Text('Calculations for mess bills based on attendance and rates.'),
          ),
          const SizedBox(height: 20),
          _buildOptionSection(
            title: '4. Mess Bill',
            child: Column(
              children: [
                const Text('Final mess bill details.'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bill Verified')));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF52b788),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Verify'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bill Resent')));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Resend'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionSection({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1b4332))),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, {bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF52b788)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
