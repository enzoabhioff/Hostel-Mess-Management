import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/dashboard_scaffold.dart';
import '../matron/attendance_view_page.dart';
import 'hostel_sec_requests_page.dart';
import 'hostel_sec_complaints_page.dart';
//  `import '../../core/logout_sc.dart';

class HostelSecretaryDashboard extends StatelessWidget {
  const HostelSecretaryDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      dashboardName: "Hostel Secretary",
      userName: "Hostel Secretary",

      // ✅ Added Logout button
      // actions: [
      //   IconButton(
      //     icon: const Icon(Icons.logout),
      //     tooltip: 'Logout',
      //     onPressed: () => LogoutHandler.logout(context),
      //   ),
      // ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔁 Switch Back Option
          Card(
            color: Colors.orange.shade50,
            child: ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: const Text(
                "Switch back to Student",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.pop(context),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Secretary Duties",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 16),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _tile(
                context,
                Icons.list_alt,
                "Requests",
                const HostelSecRequestsPage(),
              ),

              _tile(
                context,
                Icons.report_problem,
                "Complaints",
                const HostelSecComplaintsPage(),
              ),

              _tile(
                context,
                Icons.calendar_month,
                "Attendance",
                const AttendanceViewPage(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, IconData icon, String title, Widget page) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFEAF4EE),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: AppColors.primary),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
