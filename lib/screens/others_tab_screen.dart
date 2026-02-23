import 'package:flutter/material.dart';

class OthersTabScreen extends StatefulWidget {
  const OthersTabScreen({super.key});

  @override
  State<OthersTabScreen> createState() => _OthersTabScreenState();
}

class _OthersTabScreenState extends State<OthersTabScreen> {
  // ================= COLORS =================
  final Color primaryGreen = const Color(0xFF2D6A4F);
  final Color lightGreen = const Color(0xFFD8F3DC);
  final Color borderGreen = const Color(0xFF40916C);

  final TextStyle headerStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    color: Color(0xFF1B4332),
  );

  final TextStyle cellStyle = const TextStyle(
    color: Colors.black,
    fontSize: 14,
  );

  // ================= EDIT STATES =================
  bool editVegNonVeg = false;
  bool editMenu = false;
  bool editDuty = false;

  // ================= VEG / NON-VEG =================
  List<Map<String, String>> vegStudents = [
    {'name': 'Nanditha', 'room': '2115'},
    {'name': 'Aisha', 'room': '2112'},
    {'name': 'Priya', 'room': '2006'},
    {'name': 'Sneha', 'room': '2114'},
  ];

  List<Map<String, String>> nonVegStudents = [
    {'name': 'Revathy', 'room': '2107'},
    {'name': 'Anika', 'room': '2108'},
    {'name': 'Nashva', 'room': '2109'},
  ];

  // ================= MENU =================
  List<Map<String, String>> menu = [
    {'day': 'Monday', 'breakfast': 'Idli + Sambar', 'lunch': 'Rice + Dal', 'snack': 'Pazham', 'dinner': 'Chapati + Curry'},
    {'day': 'Tuesday', 'breakfast': 'Dosa', 'lunch': 'Rice + Sambar', 'snack': 'Tea + Biscuit', 'dinner': 'Puttu + Kadala'},
    {'day': 'Wednesday', 'breakfast': 'Idiyappam', 'lunch': 'Rice + Rasam', 'snack': 'Pazham', 'dinner': 'Chapati'},
    {'day': 'Thursday', 'breakfast': 'Upma', 'lunch': 'Rice + Dal', 'snack': 'Tea', 'dinner': 'Fried Rice'},
    {'day': 'Friday', 'breakfast': 'Poori', 'lunch': 'Veg Biriyani', 'snack': 'Biscuit', 'dinner': 'Chapati'},
    {'day': 'Saturday', 'breakfast': 'Dosa', 'lunch': 'Rice + Curry', 'snack': 'Tea', 'dinner': 'Noodles'},
    {'day': 'Sunday', 'breakfast': 'Idli', 'lunch': 'Special Meals', 'snack': 'Juice', 'dinner': 'Chapati'},
  ];

  // ================= DUTY =================
  List<Map<String, String>> duty = [
    {'date': '02/01/26', 'evening': '2108', 'night': '2109'},
    {'date': '02/02/26', 'evening': '2110', 'night': '2111'},
    {'date': '02/03/26', 'evening': '2112', 'night': '2113'},
    {'date': '02/04/26', 'evening': '2114', 'night': '2115'},
    {'date': '02/05/26', 'evening': '2116', 'night': '2117'},
    {'date': '02/06/26', 'evening': '2118', 'night': '2119'},
    {'date': '02/07/26', 'evening': '2120', 'night': '2121'},
    {'date': '02/08/26', 'evening': '2122', 'night': '2123'},
    {'date': '02/09/26', 'evening': '2124', 'night': '2125'},
    {'date': '02/10/26', 'evening': '2126', 'night': '2127'},
    {'date': '02/11/26', 'evening': '2128', 'night': '2129'},
    {'date': '02/12/26', 'evening': '2130', 'night': '2131'},
  ];

  @override
  Widget build(BuildContext context) {
    int vegTotal = vegStudents.length;
    int nonVegTotal = nonVegStudents.length;
    int totalCost = (vegTotal * 90) + (nonVegTotal * 110);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Others'),
        backgroundColor: primaryGreen,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // ================= MESS BILL =================
          _sectionTitle('Mess Bill'),
          Text('Veg : $vegTotal × ₹90', style: cellStyle),
          Text('Non-Veg : $nonVegTotal × ₹110', style: cellStyle),
          const SizedBox(height: 6),
          Text('Total : ₹$totalCost',
              style: const TextStyle(fontWeight: FontWeight.bold)),

          const SizedBox(height: 24),

          // ================= VEG / NON-VEG =================
          _sectionHeaderWithButton(
            'Veg / Non-Veg Students',
            editVegNonVeg,
            () => setState(() => editVegNonVeg = !editVegNonVeg),
          ),

          Row(
            children: [
              Expanded(child: _studentBox('Veg', vegStudents, editVegNonVeg)),
              const SizedBox(width: 12),
              Expanded(child: _studentBox('Non-Veg', nonVegStudents, editVegNonVeg)),
            ],
          ),

          const SizedBox(height: 28),

          // ================= MENU =================
          _sectionHeaderWithButton(
            'MENU',
            editMenu,
            () => setState(() => editMenu = !editMenu),
          ),
          _menuTable(),

          const SizedBox(height: 32),

          // ================= DUTY =================
          _sectionHeaderWithButton(
            'Duty Allocation',
            editDuty,
            () => setState(() => editDuty = !editDuty),
          ),
          _dutyTable(),
        ]),
      ),
    );
  }

  // ================= STUDENT BOX =================
  Widget _studentBox(String title, List<Map<String, String>> students, bool editable) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: borderGreen),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: headerStyle),
        const SizedBox(height: 8),
        ...students.asMap().entries.map((entry) {
          int i = entry.key;
          var s = entry.value;
          return Row(
            children: [
              Expanded(
                child: editable
                    ? TextFormField(
                        initialValue: '${s['name']} (${s['room']})',
                        onChanged: (v) {
                          final parts = v.split('(');
                          students[i]['name'] = parts[0].trim();
                          students[i]['room'] =
                              parts.length > 1 ? parts[1].replaceAll(')', '') : '';
                        },
                      )
                    : Text('${s['name']} (${s['room']})', style: cellStyle),
              ),
              if (editable)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => setState(() => students.removeAt(i)),
                )
            ],
          );
        }),
        if (editable)
          TextButton(
            onPressed: () => setState(() => students.add({'name': 'New', 'room': '---'})),
            child: const Text('Add', style: TextStyle(color: Colors.white)),
            style: TextButton.styleFrom(backgroundColor: primaryGreen),
          ),
      ]),
    );
  }

  // ================= MENU TABLE =================
  Widget _menuTable() {
    return Table(
      border: TableBorder.all(color: borderGreen),
      children: [
        _tableHeader(['Day', 'Breakfast', 'Lunch', 'Snack', 'Dinner']),
        ...menu.map((m) => _editableRow(m, editMenu)),
      ],
    );
  }

  // ================= DUTY TABLE =================
  Widget _dutyTable() {
    return Table(
      border: TableBorder.all(color: borderGreen),
      children: [
        _tableHeader(['Date', 'Evening Room No', 'Night Room No']),
        ...duty.map((d) => _editableRow(d, editDuty)),
      ],
    );
  }

  // ================= HELPERS =================
  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B4332))),
      );

  Widget _sectionHeaderWithButton(String title, bool editing, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _sectionTitle(title),
        ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
          child: Text(editing ? 'Save' : 'Edit',
              style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  TableRow _tableHeader(List<String> titles) {
    return TableRow(
      decoration: BoxDecoration(color: lightGreen),
      children: titles
          .map((t) => Padding(
                padding: const EdgeInsets.all(8),
                child: Text(t, style: headerStyle),
              ))
          .toList(),
    );
  }

  TableRow _editableRow(Map<String, String> row, bool editable) {
    return TableRow(
      children: row.values.map((v) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: editable
              ? TextFormField(
                  initialValue: v,
                  onChanged: (val) => row[row.keys.elementAt(row.values.toList().indexOf(v))] = val,
                )
              : Text(v, style: cellStyle),
        );
      }).toList(),
    );
  }
}
