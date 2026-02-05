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
    final savedRole = prefs.getString("role");

    if (token != null && savedRole != null) {
      isLoggedIn = true;
      role = savedRole;
    }

    notifyListeners();
  }

  // ✅ ROLE-BASED LOGIN
  Future<bool> login(String email, String password, String selectedRole) async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    // Convert selectedRole to lowercase to match dummyUsers data
    final normalizedRole = selectedRole.toLowerCase();

    final matches = dummyUsers.where(
          (u) =>
      u["email"] == email &&
          u["password"] == password &&
          u["role"] == normalizedRole, // 🔑 ROLE CHECK
    );

    if (matches.isNotEmpty) {
      final user = matches.first;
      final prefs = await SharedPreferences.getInstance();

      final userRole = user["role"] as String;

      await prefs.setString("token", email); // Save token
      await prefs.setString("role", userRole); // Save role
      
      isLoggedIn = true;
      role = userRole;

      isLoading = false;
      notifyListeners();
      return true;
    }

    // ❌ login failed
    isLoggedIn = false;
    role = "";
    isLoading = false;
    notifyListeners();
    return false;
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
