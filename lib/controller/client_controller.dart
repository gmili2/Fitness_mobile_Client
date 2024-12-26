import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_front/model/client.dart';
import 'package:localstorage/localstorage.dart';
import 'package:app_front/conf/config.dart';

class ClientController {
  final String apiUrl = Config.apiUrl;

  Future<List<Client>> getAllClients() async {
    await initLocalStorage();
    String token = localStorage.getItem("access_token") ?? '';
    final response = await http.get(
      Uri.parse('$apiUrl/client/clients'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);

      return body.map((dynamic item) => Client.fromJson(item)).toList();
    } else {
      throw Exception('Échec de la connexion: ${response}');
    }
  }

  Future<Map<String, dynamic>> addClient(Client client) async {
    String token = localStorage.getItem("access_token") ?? '';

    final response = await http.post(
      Uri.parse('$apiUrl/client/clients'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(client.toJson()),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Échec de l\'inscription: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> updateClient(Client client) async {
    String token = localStorage.getItem("access_token") ?? '';
    final response = await http.patch(
      Uri.parse('$apiUrl/client/clients/${client.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(client.toJson()),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Échec de modification: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> deleteClient(Client client) async {
    String token = localStorage.getItem("access_token") ?? '';
    final response = await http.delete(
      Uri.parse('$apiUrl/client/clients/${client.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Échec de la supresseion: ${response.statusCode}');
    }
  }
}
