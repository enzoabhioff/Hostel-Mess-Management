// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../office_admin/office_dashboard.dart';
// import '../dashboards/warden_dashboard.dart';
// import '../dashboards/rt_dashboard.dart';
// import '../dashboards/wingsec/wingsec_attendance.dart';
// import '../dashboards/matron/matron_dashboard.dart';
// import '../student/student_dashboard.dart';
// import '../parent/parent_dashboard.dart';
// import '../student/student_data.dart';
// import '../core/session.dart';
// import '../dashboards/security/security_dashboard.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController idController = TextEditingController();
//   final TextEditingController passController = TextEditingController();

//   bool _hidePassword = true;
//   bool _loading = false;

//   @override
//   void dispose() {
//     idController.dispose();
//     passController.dispose();
//     super.dispose();
//   }

//   // ✅ LOGIN SUCCESS MESSAGE
//   void _showSuccess() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("Login successful"),
//         backgroundColor: Color.fromARGB(255, 0, 60, 33),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }

//   // ================= LOGIN LOGIC =================
//   Future<void> _login() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _loading = true);

//     final userId = idController.text.trim();
//     final password = passController.text.trim();

//     try {
//       // ================= STUDENT LOGIN =================
//       final studentDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .get();

//       if (studentDoc.exists) {
//         final data = studentDoc.data()!;
//         if (data['password'] != password) {
//           throw "Invalid password";
//         }

//         StudentData.loadFromFirestore(data);

//         Session.userId = userId;
//         Session.role = "student";

//         _showSuccess(); // ✅ ADDED

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const StudentDashboard()),
//         );
//         return;
//       }

//       // ================= PARENT LOGIN =================
//       final parentDoc = await FirebaseFirestore.instance
//           .collection('parents')
//           .doc(userId)
//           .get();

//       if (parentDoc.exists) {
//         final parentData = parentDoc.data()!;

//         if (parentData['parentPassword'] != password) {
//           throw "Invalid parent password";
//         }

//         final studentUserId =
//             parentData['studentUserId'].toString();

//         final studentDoc2 = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(studentUserId)
//             .get();

//         if (!studentDoc2.exists) {
//           throw "Linked student not found";
//         }

//         StudentData.loadFromFirestore(studentDoc2.data()!);

//         Session.userId = userId;
//         Session.role = "parent";

//         _showSuccess(); // ✅ ADDED

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (_) => const ParentDashboard(),
//           ),
//         );
//         return;
//       }

//       // ================= STAFF LOGIN =================
//       final staffDoc = await FirebaseFirestore.instance
//           .collection('staff')
//           .doc(userId)
//           .get();

//       if (staffDoc.exists) {
//         final data = staffDoc.data()!;
//         if (data['password'] != password) {
//           throw "Invalid password";
//         }

//         final role = data['role'];

//         Session.userId = userId;
//         Session.role = role;

//         late Widget page;

//         if (role == 'office' || role == 'admin') {
//           page = const OfficeDashboard();
//         } else if (role == 'warden') {
//           page = const WardenDashboard();
//         } else if (role == 'rt') {
//           page = const RTDashboard();
//         } else if (role == 'wingsec') {
//           page = const WingSecAttendancePage();
//         } else if (role == 'matron') {
//           page = const MatronDashboard();
//         } else if (role == 'security') {
//           page = const SecurityDashboard();
//         } else {
//           throw "Unauthorized role";
//         }

//         _showSuccess(); // ✅ ADDED

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => page),
//         );
//         return;
//       }

//       throw "User not found";
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.toString())),
//       );
//     } finally {
//       setState(() => _loading = false);
//     }
//   }

//   // ================= UI =================
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(24),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const CircleAvatar(
//                     radius: 32,
//                     backgroundColor: AppColors.primary,
//                     child: Icon(
//                       Icons.apartment,
//                       color: Colors.white,
//                       size: 32,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     "HostelHub",
//                     style: TextStyle(
//                       fontSize: 26,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.primary,
//                     ),
//                   ),
//                   const SizedBox(height: 32),

//                   TextFormField(
//                     controller: idController,
//                     decoration: const InputDecoration(
//                       labelText: "User ID",
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.badge),
//                     ),
//                     validator: (v) =>
//                         v == null || v.isEmpty ? "User ID required" : null,
//                   ),
//                   const SizedBox(height: 20),

//                   TextFormField(
//                     controller: passController,
//                     obscureText: _hidePassword,
//                     decoration: InputDecoration(
//                       labelText: "Password",
//                       border: const OutlineInputBorder(),
//                       prefixIcon: const Icon(Icons.lock),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _hidePassword
//                               ? Icons.visibility_off
//                               : Icons.visibility,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _hidePassword = !_hidePassword;
//                           });
//                         },
//                       ),
//                     ),
//                     validator: (v) =>
//                         v == null || v.isEmpty ? "Password required" : null,
//                   ),
//                   const SizedBox(height: 28),

//                   SizedBox(
//                     width: double.infinity,
//                     height: 48,
//                     child: ElevatedButton(
//                       onPressed: _loading ? null : _login,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primary,
//                         foregroundColor: Colors.white,
//                       ),
//                       child: _loading
//                           ? const CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 2,
//                             )
//                           : const Text(
//                               "Login",
//                               style: TextStyle(fontSize: 16),
//                             ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

/////////NEW RENEWED//////////

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../modules/mess_sec/mess_sec_screen.dart';
import '../office_admin/office_dashboard.dart';
import '../dashboards/warden_dashboard.dart';
import '../dashboards/rt_dashboard.dart';
import '../dashboards/wingsec/wingsec_attendance.dart';
import '../dashboards/matron/matron_dashboard.dart';
import '../student/student_dashboard.dart';
import '../parent/parent_dashboard.dart';
import '../student/student_data.dart';
import '../core/session.dart';
import '../dashboards/security/security_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController idController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  bool _hidePassword = true;
  bool _loading = false;

  String? _selectedHostel;

  void _showSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Login successful"),
        backgroundColor: Color(0xFF1565C0),
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedHostel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select your hostel")),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    final userId = idController.text.trim();
    final password = passController.text.trim();

    try {
      // ================= STAFF LOGIN =================

      final staffDoc = await FirebaseFirestore.instance
          .collection('staff')
          .doc(userId)
          .get();

      if (staffDoc.exists) {
        final data = staffDoc.data()!;

        if (data['password'] == password) {
          final role = data['role'];

          Session.userId = userId;
          Session.role = role;
          Session.hostel = _selectedHostel!;

          _showSuccess();

          if (role == "admin") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => OfficeDashboard()),
            );
          } else if (role == "warden") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => WardenDashboard()),
            );
          } else if (role == "rt") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => RTDashboard()),
            );
          } else if (role == "wingsec") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => WingSecAttendancePage()),
            );
          } else if (role == "matron") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => MatronDashboard(userId: userId),
              ),
            );
          } else if (role == "messsec") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MessSecScreen()),
            );
          } else if (role == "security") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => SecurityDashboard()),
            );
          }

          return;
        }
      }

      // ================= STUDENT LOGIN =================

      final studentDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (studentDoc.exists) {
        final data = studentDoc.data()!;

        if (data['password'] == password) {
          StudentData.name = data['name'] ?? "";
          StudentData.admissionNo = data['admissionNo'] ?? "";
          StudentData.room = data['room'] ?? "";
          StudentData.department = data['department'] ?? "";
          StudentData.phone = data['phone'] ?? "";
          StudentData.email = data['email'] ?? "";

          Session.userId = userId;
          Session.role = "student";
          Session.hostel = _selectedHostel!;

          _showSuccess();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => StudentDashboard()),
          );

          return;
        }
      }

      // ================= PARENT LOGIN =================

      int? parentId = int.tryParse(userId);

      if (parentId != null) {
        final parentQuery = await FirebaseFirestore.instance
            .collection('parents')
            .where('parentUserId', isEqualTo: parentId)
            .get();

        if (parentQuery.docs.isNotEmpty) {
          final parentData = parentQuery.docs.first.data();

          if (parentData['parentPassword'] == password) {
            String studentId = parentData['studentUserId'].toString();

            final studentDocParent = await FirebaseFirestore.instance
                .collection('users')
                .doc(studentId)
                .get();

            if (studentDocParent.exists) {
              final student = studentDocParent.data()!;

              StudentData.name = student['name'] ?? "";
              StudentData.admissionNo = student['admissionNo'] ?? "";
              StudentData.room = student['room'] ?? "";
              StudentData.department = student['department'] ?? "";
              StudentData.phone = student['phone'] ?? "";
              StudentData.email = student['email'] ?? "";
            }

            Session.userId = userId;
            Session.role = "parent";
            Session.hostel = _selectedHostel!;

            _showSuccess();

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => ParentDashboard()),
            );

            return;
          }
        }
      }

      throw "Invalid user ID or password";
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),

      body: SafeArea(
        child: Column(
          children: [
            // BLUE HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),

              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),

                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: const Icon(
                          Icons.apartment,
                          color: Color(0xFF1565C0),
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Text(
                        "HostelHub",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Sign in to manage your hostel",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            // FORM
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),

                child: Form(
                  key: _formKey,

                  child: Column(
                    children: [
                      TextFormField(
                        controller: idController,
                        decoration: const InputDecoration(
                          labelText: "User ID",
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? "Enter User ID" : null,
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller: passController,
                        obscureText: _hidePassword,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _hidePassword = !_hidePassword;
                              });
                            },
                          ),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? "Enter Password" : null,
                      ),

                      const SizedBox(height: 20),

                      DropdownButtonFormField<String>(
                        value: _selectedHostel,
                        decoration: const InputDecoration(
                          labelText: "Select Hostel",
                          prefixIcon: Icon(Icons.home),
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: "Kabini",
                            child: Text("Kabini"),
                          ),
                          DropdownMenuItem(value: "Nila", child: Text("Nila")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedHostel = value;
                          });
                        },
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        height: 50,

                        child: ElevatedButton(
                          onPressed: _selectedHostel == null || _loading
                              ? null
                              : _login,

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1565C0),
                          ),

                          child: _loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Login",
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
