import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class InitViewModel extends ChangeNotifier {
  TextEditingController ipController = TextEditingController();
  TextEditingController portController = TextEditingController();

  Future<void> setSharedPrefs() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('ip', ipController.text);
    await prefs.setString('port', portController.text);
  }

  Future<void> fetchSharedPrefs() async {
    var prefs = await SharedPreferences.getInstance();
    ipController.text = prefs.getString('ip') ?? '';
    portController.text = prefs.getString('port') ?? '';

    notifyListeners();
  }

  Future<bool> checkConnection() async {
    var url =
        Uri.parse('http://${ipController.text}:${portController.text}/api/cpu');
    try {
      var response = await http.get(url).timeout(const Duration(seconds: 3));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
