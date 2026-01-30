import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "https://YOUR_SERVER_URL";

  Future<String?> login(String email, String password) async {
    final basic =
        'Basic ${base64Encode(utf8.encode('$email:$password'))}';

    final res = await http.get(
      Uri.parse("$baseUrl/login"),
      headers: {"Authorization": basic},
    );

    if (res.statusCode == 200) {
      return res.headers["authorization"]; // server token
    }
    return null;
  }
}
