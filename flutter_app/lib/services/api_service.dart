import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  static Future<Map<String, dynamic>?> fetchFridgeStatus() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/fridge')).timeout(const Duration(seconds: 3));
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
    } catch (_) {}
    return null;
  }

  static Future<void> updateFridgeTemperature(double temp) async {
    try {
      await http.post(
        Uri.parse('$baseUrl/fridge/temperature'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'temperature': temp}),
      ).timeout(const Duration(seconds: 3));
    } catch (_) {}
  }

  static Future<void> saveSkinQuiz(String name, String skinType, String skinGoal) async {
    try {
      await http.post(
        Uri.parse('$baseUrl/user/quiz'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': 'stephanie@glowup.com',
          'name': name,
          'skinType': skinType,
          'skinGoal': skinGoal,
        }),
      ).timeout(const Duration(seconds: 3));
    } catch (_) {}
  }

  static Future<void> createOrder(String customerName, List<Map<String, dynamic>> items, double total) async {
    try {
      await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'customerName': customerName,
          'items': items,
          'total': total,
        }),
      ).timeout(const Duration(seconds: 3));
    } catch (_) {}
  }
}
