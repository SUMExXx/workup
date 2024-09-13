import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workup/screens/homepage_screen.dart';
import 'package:workup/screens/serviceproviderlist_screen.dart';
import 'package:workup/screens/login_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:workup/screens/customer_registration_screen.dart';
import 'package:workup/screens/customer_registration_otp_screen.dart';
import 'package:workup/screens/serviceprovider_fullprofile_screen.dart';


void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();

  // Request permissions here
  await requestAllPermissions();
  runApp(const MyApp());
}

Future<void> requestAllPermissions() async {
  // Create a list of permissions to request
  List<Permission> permissions = [
    Permission.camera,
    Permission.microphone,
    Permission.location,
    Permission.storage,
    Permission.contacts,
    Permission.phone,
    Permission.sms,
    // Add any other permissions you need
  ];

  // Request all permissions
  Map<Permission, PermissionStatus> statuses = await permissions.request();

  // Handle the permissions' statuses if needed
  statuses.forEach((permission, status) {
    if (status.isGranted) {
      // print('${permission.toString()} granted');
    } else if (status.isDenied) {
      // print('${permission.toString()} denied');
    } else if (status.isPermanentlyDenied) {
      // The user permanently denied the permission, open app settings
      openAppSettings();
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white, // Transparent status bar
      systemNavigationBarColor: Colors.transparent, // Transparent navigation bar
      statusBarIconBrightness: Brightness.dark, // Icons' brightness in the status bar
      systemNavigationBarIconBrightness: Brightness.dark, // Icons' brightness in the nav bar
    ));

    return MaterialApp(
      initialRoute: '/',
      routes: {
        // '/': (context) => const LoginScreen(),
        '/loginScreen': (context) => const LoginScreen(),
        '/homepageScreen': (context) => const HomepageScreen(),
        '/serviceProviderListScreen' : (context) => const ServiceProviderListScreen(),
        '/customerRegistrationScreen': (context) => const CustomerRegisterScreen(),
        '/customerOtpScreen': (context) => const CustomerRegistrationOtpScreen(),
        '/serviceProviderFullProfileScreen' : (context) => const ServiceProviderFullProfileScreen(),

      },
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
