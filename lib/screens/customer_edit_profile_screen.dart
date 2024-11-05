import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:workup/utils/colors.dart';
import 'package:workup/utils/strings.dart';
import 'package:workup/utils/text_styles.dart';

class CustomerEditProfileScreen extends StatefulWidget {
  const CustomerEditProfileScreen({super.key});
  State<CustomerEditProfileScreen> createState() => _CustomerEditProfileScreenState();
}

class _CustomerEditProfileScreenState extends State<CustomerEditProfileScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  //final args
  // set function

  handleBackClick() {
    Navigator.pop(context);
  }
   
  handleChatClick() {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Center(
              child: Text(
                AppStrings.appTitle,
                style: AppTextStyles.title.merge(AppTextStyles.textWhite),
              )),
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
        body: SingleChildScrollView(

          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage('assets/profile_placeholder.png'),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Edit Picture'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                buildTextField('First Name', firstNameController),
                buildTextField('Middle Name', middleNameController),
                buildTextField('Last Name', lastNameController),
                buildTextField('Date of Birth', dobController, keyboardType: TextInputType.datetime),
                buildTextField('Email Address', emailController, keyboardType: TextInputType.emailAddress),
                buildTextField('Contact Number', contactNumberController, keyboardType: TextInputType.phone),
                buildTextField('Address Line 1', addressLine1Controller),
                buildTextField('Address Line 2', addressLine2Controller),
                buildTextField('City', cityController),
                buildTextField('State', stateController),
                buildTextField('PinCode', pinCodeController, keyboardType: TextInputType.number),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Add save action logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
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

  @override
  void dispose() {
    // Dispose controllers when not needed
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    dobController.dispose();
    emailController.dispose();
    contactNumberController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    pinCodeController.dispose();
    super.dispose();
  }
}

Widget buildTextField(String labelText, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
}
