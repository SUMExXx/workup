import 'package:flutter/material.dart';
import 'package:workup/utils/colors.dart';
import 'package:workup/utils/text_styles.dart';
import 'package:workup/utils/strings.dart';
import 'package:workup/widgets/bottom_navigation_bar.dart';
import 'package:workup/services/cart_service.dart';
import 'package:workup/services/payment_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartState cart = CartState();
  final PaymentService _paymentService = PaymentService();

  double travellingFee = 79;
  double platformFee = 49;
  double gstFee = 18;
  String providerName = 'Provider Name';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('providerName')) {
      providerName = args['providerName'];
    }
  }

  void refreshCart() => setState(() {});

  @override
  void dispose() {
    _paymentService.dispose();
    super.dispose();
  }

  String getServiceNames() {
    final cartItems = cart.getFlatTaskList();
    if (cartItems.isEmpty) return '-';
    return cartItems.map((item) => item['name']).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = cart.getFlatTaskList();
    double itemTotal = cartItems.fold(0, (sum, item) => sum + item['price'] * item['qty']);
    double totalToPay = itemTotal + travellingFee + platformFee + gstFee;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Center(
            child: Text(
              AppStrings.appTitle,
              style: AppTextStyles.title.merge(AppTextStyles.textWhite),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.chat_rounded, color: AppColors.white),
              onPressed: () {},
            )
          ],
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: cartItems.isEmpty
                    ? Center(
                  child: Text(
                    "No items in cart",
                    style: AppTextStyles.text1.merge(AppTextStyles.textPrimary),
                  ),
                )
                    : ListView.separated(
                  itemCount: cartItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item['name'],
                              style: AppTextStyles.text1.merge(AppTextStyles.textWhite)),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  cart.decrement(item['subcategoryID'], item['taskID']);
                                  refreshCart();
                                },
                                child: const Icon(Icons.remove, color: AppColors.white),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text("${item['qty']}",
                                    style: AppTextStyles.text1.merge(AppTextStyles.textWhite)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  cart.increment(
                                    item['subcategoryID'],
                                    item['taskID'],
                                    name: item['name'],
                                    price: item['price'],
                                  );
                                  refreshCart();
                                },
                                child: const Icon(Icons.add, color: AppColors.white),
                              ),
                              const SizedBox(width: 12),
                              Text("₹${(item['price'] * item['qty']).toStringAsFixed(2)}",
                                  style: AppTextStyles.text1.merge(AppTextStyles.textWhite)),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              if (cartItems.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTotalRow("Item Total", itemTotal),
                      _buildTotalRow("Travelling Fee", travellingFee),
                      _buildTotalRow("Platform Fee", platformFee),
                      _buildTotalRow("GST", gstFee),
                      const Divider(color: AppColors.white),
                      _buildTotalRow("To Pay", totalToPay, isBold: true),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () async {
                      bool paymentSuccess = await _paymentService.openCheckout(
                        amount: totalToPay.toInt(),
                      );

                      if (paymentSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Payment Successful!", style: TextStyle(color: Colors.white)),
                            backgroundColor: Colors.green,
                          ),
                        );

                        final orderId = '${DateTime.now().millisecondsSinceEpoch}';
                        final services = getServiceNames();
                        final provider = providerName;
                        final total = '₹${totalToPay.toStringAsFixed(2)}';
                        final dateNow = DateTime.now();
                        final dateFormatted = "${dateNow.day}/${dateNow.month}/${dateNow.year}";

                        final newOrder = {
                          'orderId': orderId,
                          'service': services,
                          'provider': provider,
                          'total': total,
                          'date': dateFormatted,
                          'status': 'Completed'
                        };

                        final prefs = await SharedPreferences.getInstance();
                        final String? existingOrders = prefs.getString('orderHistory');
                        List<dynamic> updatedOrders = [];

                        if (existingOrders != null) {
                          updatedOrders = List<dynamic>.from(jsonDecode(existingOrders));
                        }
                        updatedOrders.add(newOrder);
                        await prefs.setString('orderHistory', jsonEncode(updatedOrders));

                        cart.clearCart();
                        refreshCart();

                        Navigator.pushReplacementNamed(
                          context,
                          '/orderConfirmationScreen',
                          arguments: {
                            'orderId': orderId,
                            'service': services,
                            'provider': provider,
                            'total': total,
                          },
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Payment Failed! Please try again.", style: TextStyle(color: Colors.white)),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: const Text("Place Order", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, double value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: isBold
                  ? AppTextStyles.text2.merge(AppTextStyles.textWhite)
                  : AppTextStyles.text1.merge(AppTextStyles.textWhite)),
          Text("\u20b9${value.toStringAsFixed(2)}",
              style: isBold
                  ? AppTextStyles.text2.merge(AppTextStyles.textWhite)
                  : AppTextStyles.text1.merge(AppTextStyles.textWhite)),
        ],
      ),
    );
  }
}