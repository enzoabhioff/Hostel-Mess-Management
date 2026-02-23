import 'package:flutter/material.dart';
import 'otp_store.dart';

class PMScreen extends StatefulWidget {
  const PMScreen({super.key});

  @override
  State<PMScreen> createState() => _PMScreenState();
}

class _PMScreenState extends State<PMScreen> {
  final _commodityController = TextEditingController();
  final _quantityController = TextEditingController();
  final _brandController = TextEditingController();

  final List<Map<String, dynamic>> receivedItems = [];

  bool _canAccessPM() => OTPStore.approved;

  void _addReceivedItem() {
    if (!_canAccessPM()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Access denied: Mess Sec approval required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final commodity = _commodityController.text.trim();
    final qty = double.tryParse(_quantityController.text.trim()) ?? 0;
    final brand = _brandController.text.trim();

    if (commodity.isEmpty || qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid commodity and quantity'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      receivedItems.add({
        'commodity': commodity,
        'quantity': qty,
        'brand': brand,
      });
      _commodityController.clear();
      _quantityController.clear();
      _brandController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item marked as received')),
    );
  }

  @override
  void dispose() {
    _commodityController.dispose();
    _quantityController.dispose();
    _brandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Purchase Manager Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: _canAccessPM() ? Colors.green[100] : Colors.red[100],
              child: ListTile(
                leading: Icon(
                  _canAccessPM() ? Icons.check_circle : Icons.lock,
                  color: _canAccessPM() ? Colors.green : Colors.red,
                ),
                title: Text(
                  _canAccessPM()
                      ? 'Access Approved by Mess Sec'
                      : 'Access Pending: Mess Sec approval required',
                  style: TextStyle(
                      color: _canAccessPM() ? Colors.green[800] : Colors.red[800],
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _commodityController,
              decoration: const InputDecoration(
                labelText: 'Commodity Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _brandController,
              decoration: const InputDecoration(
                labelText: 'Brand (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addReceivedItem,
                child: const Text('Mark as Received'),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: receivedItems.isEmpty
                  ? const Center(child: Text('No items received yet'))
                  : ListView.builder(
                      itemCount: receivedItems.length,
                      itemBuilder: (context, index) {
                        final item = receivedItems[index];
                        return Card(
                          child: ListTile(
                            title: Text(item['commodity']),
                            subtitle: Text(
                                '${item['quantity']} units • ${item['brand'] ?? 'N/A'}'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
