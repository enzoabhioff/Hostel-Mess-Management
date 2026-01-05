import 'package:flutter/material.dart';
import 'logout_sc.dart'; // Ensure this matches your filename

class MessSecScreen extends StatefulWidget {
  const MessSecScreen({super.key});
  @override
  State<MessSecScreen> createState() => _MessSecScreenState();
}

class _MessSecScreenState extends State<MessSecScreen> {
  final ordered = <Map<String, String>>[];
  final itemC = TextEditingController();
  final qtyC = TextEditingController();

  final received = [
    {'item': 'Rice', 'qty': '200 kg'},
    {'item': 'Dal', 'qty': '80 kg'}
  ];

  int veg = 100, nonVeg = 50;
  double vegRate = 90, nonVegRate = 110;
  int days = 30;

  final menu = [
    {'day': 'Monday', 'meals': 'Idli | Rice Dal | Chapati Paneer'}
  ];
  final dayC = TextEditingController();
  final mealsC = TextEditingController();

  final duties = <String>[];
  final dutyNameC = TextEditingController();
  final dutyDescC = TextEditingController();

  final otpC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double total = (veg * vegRate + nonVeg * nonVegRate) * days;

    return Scaffold(
      backgroundColor: const Color(0xFFF5FFFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Mess Secretary',
          style: TextStyle(color: Color(0xFF2d6a4f), fontWeight: FontWeight.bold),
        ),
        // --- Added Logout Button ---
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF2d6a4f)),
            onPressed: () => LogoutHandler.logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          _card('Ordered List', Icons.shopping_cart, [
            _tf(itemC, 'Item'),
            _tf(qtyC, 'Quantity'),
            ElevatedButton(
                onPressed: () {
                  if (itemC.text.isNotEmpty) {
                    setState(() => ordered.add({'item': itemC.text, 'qty': qtyC.text}));
                    itemC.clear();
                    qtyC.clear();
                  }
                },
                child: const Text('Add')),
            ...ordered.map((e) => ListTile(title: Text(e['item']!), subtitle: Text(e['qty']!))),
          ]),
          _card(
              'Received List',
              Icons.inventory,
              received
                  .map((e) => ListTile(title: Text(e['item']!), subtitle: Text(e['qty']!)))
                  .toList()),
          _card('Mess Bill Calculation', Icons.calculate, [
            _slider('Veg: $veg', veg, (v) => setState(() => veg = v.toInt())),
            _slider('Non-Veg: $nonVeg', nonVeg, (v) => setState(() => nonVeg = v.toInt())),
            Text('Total: ₹$total',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF00695C))),
          ]),
          _card('Verification', Icons.verified, [
            ElevatedButton(
                onPressed: () => _snack('Bill forwarded to Admin'),
                child: const Text('Verify & Forward'))
          ]),
          _card('Duty Allocation', Icons.assignment, [
            _tf(dutyNameC, 'Student Name'),
            _tf(dutyDescC, 'Duty Description'),
            ElevatedButton(
                onPressed: () {
                  if (dutyNameC.text.isNotEmpty) {
                    setState(() => duties.add('${dutyNameC.text} - ${dutyDescC.text}'));
                    dutyNameC.clear();
                    dutyDescC.clear();
                  }
                },
                child: const Text('Allocate')),
            ...duties.map((d) => ListTile(title: Text(d))),
          ]),
          _card('Menu Management', Icons.restaurant_menu, [
            _tf(dayC, 'Day'),
            _tf(mealsC, 'Meals (B|L|D)'),
            ElevatedButton(
                onPressed: () {
                  if (dayC.text.isNotEmpty) {
                    setState(() => menu.add({'day': dayC.text, 'meals': mealsC.text}));
                    dayC.clear();
                    mealsC.clear();
                  }
                },
                child: const Text('Add Day')),
            ...menu.map((e) => ListTile(title: Text(e['day']!), subtitle: Text(e['meals']!))),
          ]),
          _card('Veg/Non-Veg Counts', Icons.people, [
            _slider('Veg: $veg', veg, (v) => setState(() => veg = v.toInt())),
            _slider('Non-Veg: $nonVeg', nonVeg, (v) => setState(() => nonVeg = v.toInt())),
          ]),
          _card('OTP Verification', Icons.security, [
            _tf(dutyNameC, 'Student Name'),
            ElevatedButton(onPressed: () => _snack('OTP Sent'), child: const Text('Send OTP')),
            _tf(otpC, 'Enter OTP'),
            ElevatedButton(onPressed: () => _snack('OTP Verified'), child: const Text('Verify')),
          ]),
        ]),
      ),
    );
  }

  // UI Helper methods stay the same
  Widget _card(String title, IconData icon, List<Widget> children) => Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(icon, color: const Color(0xFF40916c)),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1b4332)))
            ]),
            const SizedBox(height: 12),
            ...children,
          ]),
        ),
      );

  Widget _tf(TextEditingController c, String label) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: TextField(
            controller: c,
            decoration: InputDecoration(
                labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
      );

  Widget _slider(String label, int val, Function(double) onChange) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Slider(
              value: val.toDouble(),
              min: 0,
              max: 200,
              divisions: 200,
              onChanged: onChange,
              activeColor: const Color(0xFF52b788))
        ],
      );

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  void dispose() {
    itemC.dispose();
    qtyC.dispose();
    dayC.dispose();
    mealsC.dispose();
    dutyNameC.dispose();
    dutyDescC.dispose();
    otpC.dispose();
    super.dispose();
  }
}