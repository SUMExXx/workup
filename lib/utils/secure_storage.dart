import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

Future<void> saveToken(String token) async {
  await storage.write(key: 'jwt_token', value: token);
}

Future<String?> getToken() async {
  return await storage.read(key: 'jwt_token');
}

Future<void> deleteToken() async {
  await storage.delete(key: 'jwt_token');
}

Future<void> saveEmail(String email) async {
  await storage.write(key: 'email', value: email);
}

Future<String?> getEmail() async {
  return await storage.read(key: 'email');
}

Future<void> deleteEmail() async {
  await storage.delete(key: 'email');
}

Future<void> savePassword(String password) async {
  await storage.write(key: 'password', value: password);
}

Future<String?> getPassword() async {
  return await storage.read(key: 'password');
}

Future<void> deletePassword() async {
  await storage.delete(key: 'password');
}