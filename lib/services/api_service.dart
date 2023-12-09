import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  String baseUrl = '192.168.0.1';
  String port = '8080';
  final String prefix = '/api';

  Future<dynamic> fetchCpuData() async {
    var prefs = await SharedPreferences.getInstance();
    baseUrl = prefs.getString('ip') ?? baseUrl;
    port = prefs.getString('port') ?? port;

    final response =
        await http.get(Uri.http(baseUrl + ':' + port + prefix + '/cpu'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load CPU data');
    }
  }
}
