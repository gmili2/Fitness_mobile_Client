import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:app_front/conf/config.dart';

class UserController {
  final String apiUrl = Config.apiUrl;

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Échec de la connexion: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> me() async {
    await initLocalStorage();
    String token = localStorage.getItem("access_token") ?? '';
    final response =
        await http.post(Uri.parse('$apiUrl/auth/me'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Échec de la connexion: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> registerUser(
      String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Échec de l\'inscription: ${response.statusCode}');
    }
  }
}
