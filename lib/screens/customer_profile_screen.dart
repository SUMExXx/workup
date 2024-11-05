import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:workup/screens/customer_edit_profile_screen.dart';
import 'package:workup/utils/colors.dart';
import 'package:workup/utils/strings.dart';
import 'package:workup/utils/text_styles.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CustomerInfo? customerData; // Nullable type
  bool isLoading = true; // State to manage loading

  String? cID;
  String jsonString = '''
    {
      "imgURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
      "cID": "ramesh",
      "cName": "Ramesh Ram",
      "rating": 4.5,
      "newCustomer": true
    }''';

  void handleBackClick() {
    Navigator.pop(context);
  }

  void handleChatClick() {
    // Handle chat button click
  }

  Future<void> fetchData() async {
    try {
      // We move this logic here to ensure that the context is valid
      final Map<String, dynamic>? args =
      ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null && args.containsKey("cID")) {
        cID = args["cID"];
      }

      Map<String, dynamic> jsonData = jsonDecode(jsonString);
      customerData = CustomerInfo.fromJson(jsonData);
    } catch (e) {
      // Handle errors
      print("Error fetching data: $e");
    } finally {
      // Update loading state
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isLoading) {
      fetchData(); // Fetch data when the screen initializes
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Center(
            child: Text(
              AppStrings.appTitle,
              style: AppTextStyles.title.merge(AppTextStyles.textWhite),
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.white,
            ),
            onPressed: handleBackClick,
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.chat_rounded,
                color: AppColors.white,
              ),
              onPressed: handleChatClick,
            )
          ],
        ),
        drawer: const Drawer(),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: customerData != null // Check if customerData is not null
              ? Column(
            children: [
              Center(
                child: CustomerInfoBox(
                  imgURL: customerData!.imgURL, // Use customerData safely
                  cID: customerData!.cID,
                  cName: customerData!.cName,
                  rating: customerData!.rating,
                  newCustomer: customerData!.newCustomer,
                ),
              ),
              const SizedBox(height: 20),
              ProfileOption(
                title: 'My loyalty credits',
                onTap: () {},
              ),
              ProfileOption(
                title: 'Manage payment methods',
                onTap: () {},
              ),
              ProfileOption(
                title: 'Manage addresses',
                onTap: () {},
              ),
              ProfileOption(
                title: 'Settings',
                onTap: () {},
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Navigate to Login Screen
                  Navigator.pushReplacementNamed(context, '/loginScreen');
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Logout'),
              ),
            ],
          )
              : Center(child: Text("Failed to load customer data")), // Handle null case
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: AppStrings.home,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.groups_rounded),
              label: AppStrings.bidding,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded),
              label: AppStrings.home,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_rounded),
              label: AppStrings.home,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded),
              label: AppStrings.viewProfile,
            ),
          ],
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: AppColors.white,
          unselectedItemColor: AppColors.tertiary,
          backgroundColor: AppColors.primary,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}

// Updated CustomerInfoBox widget to take dynamic data
class CustomerInfoBox extends StatelessWidget {
  final String imgURL;
  final String cID;
  final String cName;
  final bool newCustomer;
  final double rating;

  const CustomerInfoBox({
    super.key,
    required this.imgURL,
    required this.cID,
    required this.cName,
    required this.newCustomer,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 40.0,
              backgroundImage: NetworkImage(imgURL),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.normal),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to Edit Profile Screen
                Navigator.pushNamed(context, '/customerEditProfileScreen');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Row(
                children: const [
                  Text('Edit Profile'),
                  Icon(
                    Icons.arrow_right,
                    color: AppColors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
        const Spacer(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                const Icon(Icons.star, color: AppColors.primary, size: 16.0),
                const SizedBox(width: 4),
                Text(
                  rating.toString(),
                  style: AppTextStyles.text2.merge(AppTextStyles.textPrimary),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class ProfileOption extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ProfileOption({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16.0),
          backgroundColor: AppColors.secondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, color: AppColors.white),
          ),
        ),
      ),
    );
  }
}

class CustomerInfo {
  final String imgURL;
  final String cID;
  final String cName;
  final double rating;
  final bool newCustomer;

  CustomerInfo({
    required this.imgURL,
    required this.cID,
    required this.cName,
    required this.newCustomer,
    required this.rating,
  });

  factory CustomerInfo.fromJson(Map<String, dynamic> json) {
    return CustomerInfo(
      imgURL: json['imgURL'],
      cID: json['cID'],
      cName: json['cName'],
      newCustomer: json['newCustomer'],
      rating: json['rating'].toDouble(),
    );
  }
}
