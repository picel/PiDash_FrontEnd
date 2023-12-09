import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = '192.168.0.61';
  final int port = 8080;
  final String prefix = '/api';

  Future<dynamic> fetchCpuData() async {
    final response = await http
        .get(Uri.http(baseUrl + ':' + port.toString() + prefix + '/cpu'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load CPU data');
    }
  }
}
