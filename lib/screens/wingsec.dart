// lib/screens/wingsec.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class WingSecScreen extends StatefulWidget {
  const WingSecScreen({super.key});

  @override
  State<WingSecScreen> createState() => _WingSecScreenState();
}

class _WingSecScreenState extends State<WingSecScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();

  late List<Map<String, dynamic>> rooms;

  @override
  void initState() {
    super.initState();
    _loadRoomsForDate(_selectedDate);
  }

  void _loadRoomsForDate(DateTime date) {
    rooms = List.generate(10, (i) {
      String roomNum = '10${i + 1}';
      return {
        'number': roomNum,
        'expanded': false,
        'students': List.generate(4, (j) => {
          'name': 'Student ${roomNum}-${j + 1}',
          'present': true,
          'messCut': false,
          'isVeg': true, // true = Veg, false = Non-Veg
        }),
      };
    });
  }

  void _onDaySelected(DateTime selected, DateTime focused) {
    setState(() {
      _selectedDate = selected;
      _focusedDate = focused;
      _loadRoomsForDate(selected);
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalPresent = 0;
    int vegCount = 0;
    int nonVegCount = 0;
    int messCutCount = 0;

    for (var room in rooms) {
      final students = room['students'] as List<Map<String, dynamic>>;
      for (var s in students) {
        if (s['present'] as bool) {
          totalPresent++;
          if (s['isVeg'] as bool) {
            vegCount++;
          } else {
            nonVegCount++;
          }
        }
        if (s['messCut'] as bool) messCutCount++;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wing Sec Dashboard'),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        actions: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(child: Text('Welcome, wing sec', style: TextStyle(fontSize: 16))),
          ),
          TextButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Calendar
          SliverToBoxAdapter(
            child: Card(
              margin: const EdgeInsets.all(12),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: TableCalendar(
                firstDay: DateTime.utc(2025, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDate,
                selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                onDaySelected: _onDaySelected,
                headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(color: Colors.teal[400], shape: BoxShape.circle),
                  todayDecoration: BoxDecoration(color: Colors.teal[200], shape: BoxShape.circle),
                ),
              ),
            ),
          ),

          // Date and Summary
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Text(
                    'Date: ${_selectedDate.toString().substring(0, 10)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2d6a4f)),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 1.2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: [
                      _buildSummaryCard('Total Present', totalPresent, Colors.teal),
                      _buildSummaryCard('Veg Count', vegCount, Colors.green),
                      _buildSummaryCard('Non-Veg Count', nonVegCount, Colors.red),
                      _buildSummaryCard('Mess Cut', messCutCount, Colors.orange),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Daily data saved!'), backgroundColor: Colors.green),
                        );
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Save Daily Data'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00695C),
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Room Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.5,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final room = rooms[index];
                  final students = room['students'] as List<Map<String, dynamic>>;
                  int presentCount = students.where((s) => s['present'] as bool).length;
                  return _buildExpandableRoomCard(room, presentCount);
                },
                childCount: rooms.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, int count, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[700]), textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text('$count', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableRoomCard(Map<String, dynamic> room, int presentCount) {
    final students = room['students'] as List<Map<String, dynamic>>;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => room['expanded'] = !room['expanded']),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Room ${room['number']}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.teal)),
                  Icon(room['expanded'] ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.teal, size: 18),
                ],
              ),
              Text('$presentCount / 4 Present', style: TextStyle(fontSize: 11, color: Colors.grey[700])),
              if (room['expanded'])
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: students.length,
                    itemBuilder: (context, i) {
                      final s = students[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: Text(s['name'] as String, style: const TextStyle(fontSize: 12))),
                                const Text('Present', style: TextStyle(fontSize: 11)),
                                Switch(
                                  value: s['present'] as bool,
                                  activeColor: Colors.green,
                                  onChanged: (v) => setState(() => s['present'] = v),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text('   Mess Cut', style: TextStyle(fontSize: 11)),
                                const Spacer(),
                                Switch(
                                  value: s['messCut'] as bool,
                                  activeColor: Colors.orange,
                                  onChanged: (s['present'] as bool) ? (v) => setState(() => s['messCut'] = v) : null,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text('   Veg/Non-Veg', style: TextStyle(fontSize: 11)),
                                const Spacer(),
                                Switch(
                                  value: s['isVeg'] as bool,
                                  activeColor: Colors.green,
                                  inactiveThumbColor: Colors.red,
                                  inactiveTrackColor: Colors.red[100],
                                  onChanged: (s['present'] as bool && !(s['messCut'] as bool))
                                      ? (v) => setState(() => s['isVeg'] = v)
                                      : null,
                                ),
                                Text(
                                  s['isVeg'] as bool ? 'Veg' : 'Non-Veg',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: s['isVeg'] as bool ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}