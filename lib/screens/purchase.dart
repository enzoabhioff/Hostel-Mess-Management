import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'logout_sc.dart'; 

class PurchaseManagerScreen extends StatefulWidget {
  const PurchaseManagerScreen({super.key});

  @override
  State<PurchaseManagerScreen> createState() => _PurchaseManagerScreenState();
}

class _PurchaseManagerScreenState extends State<PurchaseManagerScreen> {
  final _receivedFormKey = GlobalKey<FormState>();
  final _receivedItemController = TextEditingController();
  final _receivedQtyController = TextEditingController();
  final _receivedBrandController = TextEditingController();

  final _issueFormKey = GlobalKey<FormState>();
  final _issueItemController = TextEditingController();
  final _issueQtyController = TextEditingController();
  final _issueReasonController = TextEditingController();

  final List<Map<String, dynamic>> _receivedToday = [];
  final List<Map<String, dynamic>> _issuesReported = [];

  @override
  void dispose() {
    _receivedItemController.dispose();
    _receivedQtyController.dispose();
    _receivedBrandController.dispose();
    _issueItemController.dispose();
    _issueQtyController.dispose();
    _issueReasonController.dispose();
    super.dispose();
  }

  void _submitReceived() {
    if (_receivedFormKey.currentState!.validate()) {
      setState(() {
        _receivedToday.add({
          'item': _receivedItemController.text.trim(),
          'qty': int.tryParse(_receivedQtyController.text.trim()) ?? 0,
          'brand': _receivedBrandController.text.trim().isEmpty ? '—' : _receivedBrandController.text.trim(),
          'time': DateTime.now().toIso8601String(),
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Received item added successfully')));
      _receivedItemController.clear();
      _receivedQtyController.clear();
      _receivedBrandController.clear();
    }
  }

  void _submitIssue() {
    if (_issueFormKey.currentState!.validate()) {
      setState(() {
        _issuesReported.add({
          'item': _issueItemController.text.trim(),
          'qty': int.tryParse(_issueQtyController.text.trim()) ?? 0,
          'reason': _issueReasonController.text.trim(),
          'time': DateTime.now().toIso8601String(),
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Issue reported successfully')));
      _issueItemController.clear();
      _issueQtyController.clear();
      _issueReasonController.clear();
    }
  }

  Future<void> _submitAllEntries() async {
    if (_receivedToday.isEmpty && _issuesReported.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No entries to submit today')));
      return;
    }

    try {
      // ✅ NEW: Upload to Firestore for Mess Sec to see
      await FirebaseFirestore.instance.collection('daily_deliveries').add({
        'receivedItems': _receivedToday,
        'issues': _issuesReported,
        'submittedAt': FieldValue.serverTimestamp(),
        'status': 'PENDING_VERIFICATION',
      });

      if (!mounted) return;
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.green.shade50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(children: [Icon(Icons.send, color: Colors.green), SizedBox(width: 12), Text('Success', style: TextStyle(color: Colors.green))]),
          content: const Text('Deliveries sent to Mess Secretary successfully.'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
        ),
      );

      setState(() {
        _receivedToday.clear();
        _issuesReported.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Widget _buildOrderedItems() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('purchase_orders').orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final orders = snapshot.data!.docs;
        if (orders.isEmpty) return const Center(child: Text('No orders yet', style: TextStyle(color: Colors.grey)));

        return Column(
          children: orders.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final items = (data['items'] as List<dynamic>?)?.map((e) => e as Map<String, dynamic>).toList() ?? [];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ExpansionTile(
                leading: const Icon(Icons.shopping_cart_outlined, color: Colors.orange),
                title: Text('Order ID: ${doc.id.substring(0, 5)}...'),
                subtitle: Text('Status: ${data['status'] ?? '—'}'),
                children: [
                  ...items.map((item) => ListTile(
                    title: Text(item['item'] ?? '—'),
                    subtitle: Text('Qty: ${item['qty'] ?? '—'} • ${item['brand'] ?? '—'}'),
                  )),
                  if ((data['status'] ?? '') != 'RECEIVED')
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () => doc.reference.update({'status': 'RECEIVED'}),
                        child: const Text('Mark as Received'),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Manager Dashboard'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 2, 120, 85),
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [IconButton(icon: const Icon(Icons.logout), onPressed: () => LogoutHandler.logout(context))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(children: const [
                Icon(Icons.inventory_2_outlined, size: 80, color: Color.fromARGB(255, 2, 113, 72)),
                SizedBox(height: 16),
                Text('Welcome, Purchase Manager!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Manage purchases and inventory efficiently.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.black54)),
              ]),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('Pending / Ordered Items'),
            _buildOrderedItems(),
            const SizedBox(height: 32),
            _buildSectionHeader('Record Received Items'),
            Form(key: _receivedFormKey, child: Card(
              elevation: 2,
              child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
                TextFormField(controller: _receivedItemController, decoration: const InputDecoration(labelText: 'Item Name', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextFormField(controller: _receivedQtyController, decoration: const InputDecoration(labelText: 'Quantity', border: OutlineInputBorder()), keyboardType: TextInputType.number),
                const SizedBox(height: 12),
                TextFormField(controller: _receivedBrandController, decoration: const InputDecoration(labelText: 'Brand / Supplier', border: OutlineInputBorder())),
                const SizedBox(height: 16),
                ElevatedButton.icon(icon: const Icon(Icons.add_circle_outline), label: const Text('Add Received Item'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, minimumSize: const Size.fromHeight(48)), onPressed: _submitReceived),
              ])),
            )),
            const SizedBox(height: 32),
            _buildSectionHeader('Report Missed / Faulty Items'),
            Form(key: _issueFormKey, child: Card(
              elevation: 2,
              child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
                TextFormField(controller: _issueItemController, decoration: const InputDecoration(labelText: 'Item Name', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextFormField(controller: _issueQtyController, decoration: const InputDecoration(labelText: 'Qty Affected', border: OutlineInputBorder()), keyboardType: TextInputType.number),
                const SizedBox(height: 12),
                TextFormField(controller: _issueReasonController, decoration: const InputDecoration(labelText: 'Reason', border: OutlineInputBorder())),
                const SizedBox(height: 16),
                ElevatedButton.icon(icon: const Icon(Icons.report_problem), label: const Text('Report Issue'), style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, minimumSize: const Size.fromHeight(48)), onPressed: _submitIssue),
              ])),
            )),
            const SizedBox(height: 40),
            Center(child: ElevatedButton.icon(
              icon: const Icon(Icons.send),
              label: const Text('Submit All Entries for Today'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 5, 129, 118), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16), textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              onPressed: _submitAllEntries,
            )),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1976D2))),
  );
}