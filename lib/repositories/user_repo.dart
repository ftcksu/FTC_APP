import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ftc_application/repositories/ftc_repository.dart';
import 'package:ftc_application/src/models/Member.dart';

class UserRepo {
  final FtcRepository ftcRepository;
  final storage = new FlutterSecureStorage();
  Member? member;

  UserRepo({required this.ftcRepository});

  Future<String> authenticate({
    required String username,
    required String password,
  }) async {
    String auth = await ftcRepository.login(username, password);
    return auth;
  }

  Future<void> deleteToken() async {
    await storage.delete(key: "user_token");
    await storage.delete(key: "username");
    await storage.delete(key: "password");
    return;
  }

  Future<void> persistToken(String token) async {
    await storage.write(key: "user_token", value: token);
  }

  Future<void> persistUserCredentials(String username, String password) async {
    await storage.write(key: "username", value: username);
    await storage.write(key: "password", value: password);
  }

  Future<bool> hasToken() async {
    return await storage.read(key: "user_token") != null;
  }
}
