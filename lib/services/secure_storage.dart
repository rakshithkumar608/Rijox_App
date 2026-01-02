import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final storage = const FlutterSecureStorage();

  Future saveToken(String token) async =>
      await storage.write(key: "token", value: token);

  Future<String?> getToken() async => await storage.read(key: "token");

  Future clear() async => await storage.deleteAll();
}
