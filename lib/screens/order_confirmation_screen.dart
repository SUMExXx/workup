import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workup/utils/colors.dart';
import 'package:workup/utils/text_styles.dart';
import 'package:workup/widgets/bottom_navigation_bar.dart';
import 'package:workup/widgets/drawer.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> orderData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};

    final String currentTime =
    DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());

    return SafeArea(
      child: Scaffold(
        drawer: const CustomDrawer(),
        bottomNavigationBar: const CustomBottomNavigationBar(),
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Center(
            child: Text("Order Confirmation",
                style: AppTextStyles.title.merge(AppTextStyles.textWhite)),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(   // <-- Wrap whole body with scroll to prevent any overflow
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, size: 80, color: Colors.green),
                const SizedBox(height: 16),
                Text(
                  "Order Confirmed!",
                  style: AppTextStyles.title.merge(AppTextStyles.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  "Your order has been placed successfully.",
                  style: AppTextStyles.textSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                buildDetailRow("Order ID", orderData['orderId'] ?? '-'),
                buildMultilineDetailRow("Service", orderData['service'] ?? '-'),
                buildDetailRow("Provider", orderData['provider'] ?? '-'),
                buildDetailRow("Total Amount", orderData['total'] ?? '-'),
                buildDetailRow("Confirmed On", currentTime),

                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/orderHistoryScreen'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                  child: const Text("View My Orders",
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/home'),
                  child: const Text("Back to Home"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // For normal (single-line) fields
  Widget buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,   // <-- important for alignment
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: AppTextStyles.textSmallBold,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTextStyles.textSmall,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // For multi-line service names
  Widget buildMultilineDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Top align the text
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: AppTextStyles.textSmallBold,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: AppTextStyles.textSmall,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}