import 'package:flutter/material.dart';
import 'logout_sc.dart';
import 'otp_store.dart';
import 'others_tab_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const primaryGreen = Color(0xFF2D6A4F);
const accentGreen = Color(0xFF40916C);
const lightGreen = Color(0xFFD8F3DC);

class MessSecScreen extends StatefulWidget {
  const MessSecScreen({super.key});

  @override
  State<MessSecScreen> createState() => _MessSecScreenState();
}

class _MessSecScreenState extends State<MessSecScreen> {
  final ordered = <Map<String, String>>[];
  final finalList = <Map<String, String>>[];

  final itemC = TextEditingController();
  final qtyC = TextEditingController();
  final brandC = TextEditingController();
  final _studentNumberController = TextEditingController();

  Future<void> _saveFinalListToFirestore() async {
    if (finalList.isEmpty) return;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      await FirebaseFirestore.instance.collection('purchase_orders').add({
        'messSecId': uid,
        'items': finalList,
        'status': 'SENT_TO_PM',
        'createdAt': FieldValue.serverTimestamp(),
      });
      setState(() => finalList.clear());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Final list sent to Purchase Manager')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Widget _buildReceivedListStream() {
    return StreamBuilder<QuerySnapshot>(
      // ✅ NEW: Listens for deliveries from the Purchase Manager
      stream: FirebaseFirestore.instance.collection('daily_deliveries').orderBy('submittedAt', descending: true).limit(1).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Padding(padding: EdgeInsets.all(16), child: Text('No items received yet', style: TextStyle(color: Colors.grey)));
        }

        final doc = snapshot.data!.docs.first;
        final data = doc.data() as Map<String, dynamic>;
        final items = List<Map<String, dynamic>>.from(data['receivedItems'] ?? []);

        return Column(
          children: [
            DataTable(
              headingRowColor: MaterialStateProperty.all(lightGreen),
              columns: const [DataColumn(label: Text('Item')), DataColumn(label: Text('Qty')), DataColumn(label: Text('Brand'))],
              rows: items.map((e) => DataRow(cells: [
                DataCell(Text(e['item'] ?? '')),
                DataCell(Text(e['qty'].toString())),
                DataCell(Text(e['brand'] ?? '')),
              ])).toList(),
            ),
            const SizedBox(height: 16),
            _greenButton('Verify & Forward', () async {
              await doc.reference.update({'status': 'VERIFIED'});
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Delivery verified and forwarded!')));
            }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FFFB),
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, centerTitle: true, title: const Text('Mess Secretary', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)), actions: [IconButton(icon: const Icon(Icons.logout, color: primaryGreen), onPressed: () => LogoutHandler.logout(context))]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _card('Ordered List', Icons.shopping_cart, [
              _tf(itemC, 'Item'), _tf(qtyC, 'Quantity'), _tf(brandC, 'Brand'),
              _greenButton('Add to Current List', () {
                if (itemC.text.isNotEmpty) {
                  setState(() => ordered.add({'item': itemC.text, 'qty': qtyC.text, 'brand': brandC.text}));
                  itemC.clear(); qtyC.clear(); brandC.clear();
                }
              }),
              ...ordered.map((e) => ListTile(title: Text(e['item']!), subtitle: Text('${e['qty']} • ${e['brand']}'))),
            ]),
            _card('Final List', Icons.playlist_add_check, [
              _greenButton('Move All to Final', () { setState(() { finalList.addAll(ordered); ordered.clear(); }); }),
              const SizedBox(height: 12),
              _greenButton('Send to Purchase Manager', _saveFinalListToFirestore),
              ...finalList.map((e) => ListTile(title: Text(e['item']!), subtitle: Text('${e['qty']} • ${e['brand']}'))),
            ]),
            _card('Received List', Icons.inventory, [_buildReceivedListStream()]),
            _card('Student OTP Generation', Icons.lock, [_tf(_studentNumberController, 'Student Number'), _greenButton('Generate OTP', () {})]),
            const SizedBox(height: 24),
            ElevatedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OthersTabScreen())), icon: const Icon(Icons.more_horiz), label: const Text('Others'), style: ElevatedButton.styleFrom(backgroundColor: accentGreen, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)))),
          ],
        ),
      ),
    );
  }

  Widget _card(String title, IconData icon, List<Widget> children) => Card(
    elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), margin: const EdgeInsets.symmetric(vertical: 12),
    child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: lightGreen, borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: primaryGreen)), const SizedBox(width: 12), Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryGreen))]),
      const SizedBox(height: 16), ...children,
    ])),
  );

  Widget _tf(TextEditingController c, String l) => Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: TextField(controller: c, decoration: InputDecoration(labelText: l, filled: true, fillColor: Colors.white, focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: primaryGreen, width: 2), borderRadius: BorderRadius.circular(12)), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: accentGreen.withOpacity(0.4)), borderRadius: BorderRadius.circular(12)))));

  Widget _greenButton(String t, VoidCallback o) => SizedBox(width: double.infinity, child: ElevatedButton(onPressed: o, style: ElevatedButton.styleFrom(backgroundColor: accentGreen, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text(t, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600))));
}
