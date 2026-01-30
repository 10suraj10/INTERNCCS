import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/dummy_users.dart';

class AuthViewModel extends ChangeNotifier {
  bool isLoading = false;
  bool isLoggedIn = false;
  String role = "";

  Future init() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token != null) {
      isLoggedIn = true;
      role = prefs.getString("role") ?? "";
    }
    notifyListeners();
  }

  Future login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    final matches = dummyUsers.where(
      (u) => u["email"] == email && u["password"] == password,
    );

    if (matches.isNotEmpty) {
      final user = matches.first;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", email);
      await prefs.setString("role", user["role"] ?? "");
      
      isLoggedIn = true;
      role = user["role"] ?? "";
    } else {
      isLoggedIn = false;
      role = "";
    }

    isLoading = false;
    notifyListeners();
  }

  Future logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    await prefs.remove("role");
    isLoggedIn = false;
    role = "";
    notifyListeners();
  }
}
