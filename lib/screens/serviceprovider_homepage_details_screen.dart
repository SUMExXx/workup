import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:workup/utils/colors.dart';
import 'package:workup/utils/strings.dart';
import 'package:workup/utils/text_styles.dart';

import '../widgets/sp_bottom_navigation_bar.dart';

class SPHomeDetails extends StatefulWidget {
  const   SPHomeDetails({super.key});

  @override
  State<SPHomeDetails> createState() => _SPHomeDetailsState();
}

class _SPHomeDetailsState extends State<SPHomeDetails> {
  List<Map<String, String>> pendingOrders = [];
  List<Map<String, String>> workingOrders = [];
  List<Map<String, String>> completedOrders = [];
  List<Map<String, String>> cancelledOrders = [];

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchPendingOrders();
    fetchCompletedOrders();
    fetchCancelledOrders();
  }

  Future<void> fetchPendingOrders() async {
    final url = Uri.parse(
        'https://workup.koyeb.app/serviceProviders/getPendingOrders');
    final email = 'aayushri1302@gmail.com';

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      setState(() {
        pendingOrders = data.map<Map<String, String>>((order) {
          final items = order['items'] as List<dynamic>;
          String subcategories = '';
          String tasks = '';
          String qty = '';

          if (items.isNotEmpty) {
            final firstItem = items[0];
            subcategories = firstItem['subcategoryId'] ?? '';

            if (firstItem['tasks'] != null && firstItem['tasks'].isNotEmpty) {
              final task = firstItem['tasks'][0];
              tasks = task['taskId'] ?? '';
              qty = task['qty']?.toString() ?? '';
            }
          }

          return {
            'id': order['orderId'] ?? '',
            'customer': order['email'] ?? '',
            'subcategories': subcategories,
            'tasks': tasks,
            'quantity': qty,
            'amount': '450',
            // You can update this if amount exists in real response
            'date': order['dateTime'] ?? '',
            'address': '10/4 Geeta Bhavan Indore',
            // You can make this dynamic too
          };
        }).toList();
      });

      startAutoDismissTimer();
    } else {
      debugPrint('Failed to load pending orders: ${response.statusCode}');
    }
  }

  Future<void> fetchCompletedOrders() async {
    final url = Uri.parse(
        'https://workup.koyeb.app/serviceProviders/getCompletedOrders');
    final email = 'aayushri1302@gmail.com'; // Replace with dynamic email if needed

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      setState(() {
        completedOrders = data.map<Map<String, String>>((order) {
          final items = order['items'] as List<dynamic>;
          String tasks = '';
          String payment = '';
          String address = '';

          if (items.isNotEmpty) {
            final firstItem = items[0];
            tasks = firstItem['taskId'] ?? '';
          }

          payment = order['paymentStatus'] ?? '600';
          address = order['address'] ?? '13/1 MG Road Indore';

          return {
            'id': order['_id'] ?? '',
            'customer': order['email'] ?? '',
            'tasks': tasks,
            'amount': order['totalAmount'] ?? '0',
            'date': order['dateTime'] ?? '',
            'address': address,
            'payment': payment,
          };
        }).toList();
      });
    } else {
      debugPrint('Failed to load completed orders: ${response.statusCode}');
    }
  }

  Future<void> fetchCancelledOrders() async {
    final url = Uri.parse(
        'https://workup.koyeb.app/serviceProviders/getCancelledOrders');
    final email = 'aayushri1302@gmail.com'; // Replace with dynamic email if needed

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      setState(() {
        cancelledOrders = data.map<Map<String, String>>((order) {
          final items = order['items'] as List<dynamic>;
          String tasks = '';
          String payment = '';
          String address = '';

          if (items.isNotEmpty) {
            final firstItem = items[0];
            tasks = firstItem['taskId'] ?? '';
          }

          payment = order['paymentStatus'] ?? 'Unknown';
          address = order['address'] ?? 'N/A';

          return {
            'id': order['_id'] ?? '',
            'customer': order['email'] ?? '',
            'tasks': tasks,
            'amount': order['totalAmount'] ?? '0',
            'date': order['dateTime'] ?? '',
            'address': address,
            'payment': payment,
          };
        }).toList();
      });
    } else {
      debugPrint('Failed to load cancelled orders: ${response.statusCode}');
    }
  }

  void startAutoDismissTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(minutes: 3), () {
      setState(() {
        pendingOrders.clear();
      });
    });
  }

  void acceptOrder(int index) {
    _timer?.cancel();
    setState(() {
      workingOrders.add(pendingOrders[index]);
      pendingOrders.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ The order is Accepted'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    startAutoDismissTimer();
  }

  void rejectOrder(int index) {
    _timer?.cancel();
    setState(() {
      pendingOrders.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('❌ The order is Rejected'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );

    startAutoDismissTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          automaticallyImplyLeading: false,
          title: Text(
            AppStrings.appTitle, // String from your strings.dart
            style: AppTextStyles.title.merge(
                AppTextStyles.textWhite), // Merged text style
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Working'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        bottomNavigationBar: const SPCustomBottomNavigationBar(),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: pendingOrders.isEmpty
                  ? const EmptyStateTab(
                title: 'No pending orders',
                subtitle: 'Tap on Bidding Page and get started',
                buttonText: 'View Bidding Page',
              )
                  : Column(
                children: [
                  buildHighlightedOrderCard(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: pendingOrders.length,
                      itemBuilder: (context, index) {
                        final order = pendingOrders[index];
                        return buildOrderCard(order, index);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: workingOrders.isEmpty
                  ? const Center(child: Text('No working orders'))
                  : ListView.builder(
                itemCount: workingOrders.length,
                itemBuilder: (context, index) {
                  final order = workingOrders[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: const Icon(Icons.build, color: Colors.purple),
                      title: Text('${order['tasks']} for ${order['customer']}'),
                      subtitle: Text(
                          'Order ID: ${order['id']}\nAmount: ${order['amount']}\nDate: ${order['date']}\nAddress: ${order['address']}'),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: completedOrders.length,
                itemBuilder: (context, index) {
                  final order = completedOrders[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    color: Colors.green.shade50,
                    child: ListTile(
                      title: Text('${order['tasks']} - ${order['amount']}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
                      subtitle: Text(
                          'Order ID: ${order['id']}\nCustomer: ${order['customer']}\nDate: ${order['date']}\nAddress: ${order['address']}\nPayment: ${order['payment']}'),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: cancelledOrders.isEmpty
                  ? const Center(child: Text('No cancelled orders'))
                  : ListView.builder(
                itemCount: cancelledOrders.length,
                itemBuilder: (context, index) {
                  final order = cancelledOrders[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    color: Colors.red.shade50,
                    child: ListTile(
                      title: Text('${order['tasks']} - ${order['amount']}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red)),
                      subtitle: Text(
                          'Order ID: ${order['id']}\nCustomer: ${order['customer']}\nDate: ${order['date']}\nAddress: ${order['address']}\nPayment: ${order['payment']}'),
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

  Widget buildHighlightedOrderCard() {
    final order = pendingOrders.isNotEmpty ? pendingOrders[0] : null;
    if (order == null) return const SizedBox.shrink();

    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.purple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("New Order - ${order['id']}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.purple)),
            const SizedBox(height: 5),
            Text('Customer: ${order['customer']}',
                style: const TextStyle(color: Colors.purple)),
            const SizedBox(height: 5),
            Text('Tasks: ${order['tasks']}',
                style: const TextStyle(color: Colors.purple)),
            const SizedBox(height: 5),
            Text('Amount: ${order['amount']}',
                style: const TextStyle(color: Colors.purple)),
            const SizedBox(height: 5),
            Text('Date: ${order['date']}',
                style: const TextStyle(color: Colors.purple)),
            const SizedBox(height: 5),
            Text('Address: ${order['address']}',
                style: const TextStyle(color: Colors.purple)),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => acceptOrder(0),
                  child: const Text('Accept'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => rejectOrder(0),
                  child: const Text('Reject'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOrderCard(Map<String, String> order, int index) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text('Task: ${order['tasks']}'),
        subtitle: Text(
          'Order ID: ${order['id']}\n'
              'Subcategory: ${order['subcategories']}\n'
              'Quantity: ${order['quantity']}\n'
              'Amount: ${order['amount']}\n'
              'Date: ${order['date']}\n'
              'Address: ${order['address']}',
        ),
        trailing: Wrap(
          spacing: 10,
          children: [
            IconButton(
              icon: const Icon(Icons.check_circle, color: Colors.green),
              onPressed: () => acceptOrder(index),
            ),
            IconButton(
              icon: const Icon(Icons.cancel, color: Colors.red),
              onPressed: () => rejectOrder(index),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyStateTab extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;

  const EmptyStateTab({
    required this.title,
    required this.subtitle,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(subtitle, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Implement navigation to the bidding page
            },
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}
