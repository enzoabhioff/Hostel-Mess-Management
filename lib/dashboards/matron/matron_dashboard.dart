// import 'package:flutter/material.dart';
// import '../../core/app_colors.dart';
// import '../../core/dashboard_scaffold.dart';
// import '../../staff/profile/staff_profile_page.dart';

// import 'attendance_view_page.dart';
// import 'outgoing_category_page.dart';
// import 'gate_requests_page.dart';
// import 'send_notification_page.dart';
// import '../emergency/emergency_page.dart';

// class MatronDashboard extends StatelessWidget {
// final String userId;

// const MatronDashboard({
// super.key,
// required this.userId,
// });

// @override
// Widget build(BuildContext context) {
// return DashboardScaffold(
// dashboardName: "Matron Dashboard",
// userName: "Hostel Matron",
// onProfileTap: () {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (_) => StaffProfilePage(userId: userId),
// ),
// );
// },
// body: GridView.count(
// padding: const EdgeInsets.all(16),
// crossAxisCount: 2,
// crossAxisSpacing: 16,
// mainAxisSpacing: 16,
// children: [
// _tile(context, Icons.fact_check, "Attendance", const AttendanceViewPage()),
// _tile(context, Icons.directions_walk, "Outgoing Records", const OutgoingCategoryPage()),
// _tile(context, Icons.exit_to_app, "Gate Requests", const GateRequestsPage()),
// _tile(context, Icons.warning, "Emergency Alerts", const EmergencyPage()),
// _tile(context, Icons.notifications, "Send Notification", const SendNotificationPage()),
// ],
// ),
// );
// }

// Widget *tile(BuildContext context, IconData icon, String title, Widget page) {
// return InkWell(
// onTap: () {
// Navigator.push(
// context,
// MaterialPageRoute(builder: (*) => page),
// );
// },
// child: Container(
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(20),
// color: Colors.white,
// boxShadow: [
// BoxShadow(
// color: Colors.black.withOpacity(0.05),
// blurRadius: 10,
// ),
// ],
// ),
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Icon(icon, size: 32, color: AppColors.primary),
// const SizedBox(height: 10),
// Text(
// title,
// textAlign: TextAlign.center,
// style: const TextStyle(fontWeight: FontWeight.w500),
// ),
// ],
// ),
// ),
// );
// }
// }

import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class MatronDashboard extends StatelessWidget {
  final String userId;

  const MatronDashboard({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Matron Dashboard"),
        backgroundColor: AppColors.primary,
      ),

      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,

        children: [
          _tile(Icons.fact_check, "Attendance"),

          _tile(Icons.directions_walk, "Outgoing Records"),

          _tile(Icons.exit_to_app, "Gate Requests"),

          _tile(Icons.warning, "Emergency Alerts"),

          _tile(Icons.notifications, "Send Notification"),
        ],
      ),
    );
  }

  Widget _tile(IconData icon, String title) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 34, color: AppColors.primary),

          const SizedBox(height: 10),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
