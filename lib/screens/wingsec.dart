import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_sc.dart'; // Your login screen
import 'logout_sc.dart'; // The logout handler you wrote

class WingSecScreen extends StatefulWidget {
  const WingSecScreen({super.key});

  @override
  State<WingSecScreen> createState() => _WingSecScreenState();
}

class _WingSecScreenState extends State<WingSecScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  bool _isSaving = false;

  List<Map<String, dynamic>> rooms = [];

  // ---------- DATE LOGIC ----------
  bool get isToday {
    final now = DateTime.now();
    return _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;
  }

  bool get isPast {
    final today = DateTime.now();
    return DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day)
        .isBefore(DateTime(today.year, today.month, today.day));
  }

  bool get isFuture {
    final today = DateTime.now();
    return DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day)
        .isAfter(DateTime(today.year, today.month, today.day));
  }

  String get dateKey => _selectedDate.toIso8601String().substring(0, 10);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // ---------- LOAD DATA ----------
  Future<void> _loadData() async {
    final roomSnap = await FirebaseFirestore.instance.collection('rooms').get();
    final studentSnap =
        await FirebaseFirestore.instance.collection('students').get();
    final attendanceSnap = await FirebaseFirestore.instance
        .collection('attendance')
        .doc(dateKey)
        .get();

    final savedRooms = attendanceSnap.exists ? attendanceSnap['rooms'] ?? [] : [];

    List<Map<String, dynamic>> tempRooms = [];

    for (var room in roomSnap.docs) {
      final roomNo = room['roomNumber'].toString();

      final students = studentSnap.docs
          .where((s) => s['room'] == roomNo)
          .map((s) {
        final savedRoom = savedRooms.firstWhere(
          (r) => r['number'] == roomNo,
          orElse: () => null,
        );

        final savedStudent = savedRoom != null
            ? (savedRoom['students'] as List).firstWhere(
                (st) => st['studentId'] == s.id,
                orElse: () => null,
              )
            : null;

        return {
          'studentId': s.id,
          'name': s['name'],
          'present': savedStudent != null
              ? savedStudent['present']
              : (!isFuture),
          'messCut': savedStudent != null ? savedStudent['messCut'] : false,
        };
      }).toList();

      if (students.isNotEmpty) {
        tempRooms.add({'number': roomNo, 'students': students});
      }
    }

    setState(() => rooms = tempRooms);
  }

  // ---------- SAVE ----------
  Future<void> _saveAttendance() async {
    if (!isToday) return;

    setState(() => _isSaving = true);

    await FirebaseFirestore.instance
        .collection('attendance')
        .doc(dateKey)
        .set({
      'date': dateKey,
      'locked': true,
      'rooms': rooms,
    });

    setState(() => _isSaving = false);
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    int totalIn = 0, totalCut = 0;

    for (var r in rooms) {
      for (var s in r['students']) {
        if (s['present'] == true) totalIn++;
        if (s['messCut'] == true) totalCut++;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wing Secretary'),
        backgroundColor: Colors.teal[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => LogoutHandler.logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (!isToday || _isSaving) ? null : _saveAttendance,
        backgroundColor: Colors.teal[800],
        child: _isSaving
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.cloud_upload),
      ),
      body: Column(
        children: [
          // ---------- CALENDAR ----------
          TableCalendar(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDate,
            calendarFormat: CalendarFormat.week,
            selectedDayPredicate: (d) => isSameDay(d, _selectedDate),
            onDaySelected: (d, f) {
              setState(() {
                _selectedDate = d;
                _focusedDate = f;
              });
              _loadData();
            },
          ),

          // ---------- SUMMARY ----------
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _summary('IN', totalIn, Colors.green),
                _summary('CUT', totalCut, Colors.orange),
              ],
            ),
          ),

          // ---------- ROOMS ----------
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: rooms.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, i) => _roomTile(rooms[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summary(String label, int val, Color col) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text('$val',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: col)),
      ],
    );
  }

  Widget _roomTile(Map<String, dynamic> room) {
    final students = room['students'] as List;
    final present = students.where((s) => s['present'] == true).length;

    return InkWell(
      onTap: (!isToday) ? null : () => _editRoom(room),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.teal.shade100),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(room['number'],
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('$present / ${students.length}',
                style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }

  // ---------- EDIT ROOM ----------
  void _editRoom(Map<String, dynamic> room) {
    showModalBottomSheet(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setModal) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Room ${room['number']}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const Divider(),
                ...room['students'].map<Widget>((s) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(s['name']),
                      Row(
                        children: [
                          ChoiceChip(
                            label: Text(s['present'] ? 'IN' : 'ABSENT'),
                            selected: s['present'],
                            selectedColor: Colors.green,
                            backgroundColor: Colors.red,
                            onSelected: (_) {
                              setModal(() {
                                s['present'] = !s['present'];
                              });
                              setState(() {});
                            },
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text('CUT'),
                            selected: s['messCut'],
                            selectedColor: Colors.red,
                            backgroundColor: Colors.green,
                            onSelected: (_) {
                              setModal(() {
                                s['messCut'] = !s['messCut'];
                              });
                              setState(() {});
                            },
                          ),
                        ],
                      )
                    ],
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
