import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Android emulator -> 10.0.2.2 | iOS simulator -> localhost | real phone -> your PC's LAN IP
const String baseUrl = 'http://10.0.2.2:5000/api';

class Doctor {
  final String id, name, specialization, image, timings;
  Doctor(this.id, this.name, this.specialization, this.image, this.timings);
  factory Doctor.fromJson(Map<String, dynamic> j) =>
      Doctor(j['_id'], j['name'], j['specialization'], j['image'] ?? '', j['timings'] ?? '');
}

class Api {
  static String? token, userId;

  static Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    token = p.getString('token');
    userId = p.getString('userId');
  }

  static Future<void> logout() async {
    final p = await SharedPreferences.getInstance();
    await p.clear();
    token = userId = null;
  }

  static Map<String, String> get _h => {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  static Future<void> auth(String path, String email, String password) async {
    final r = await http.post(Uri.parse('$baseUrl/auth/$path'),
        headers: _h, body: jsonEncode({'email': email, 'password': password}));
    final d = jsonDecode(r.body);
    if (r.statusCode >= 300) throw d['message'] ?? 'Something went wrong';
    final p = await SharedPreferences.getInstance();
    token = d['token'];
    userId = d['userId'];
    await p.setString('token', token!);
    await p.setString('userId', userId!);
  }

  static Future<List<Doctor>> doctors(String spec) async {
    final r = await http.get(Uri.parse('$baseUrl/doctors').replace(queryParameters: {'specialization': spec}), headers: _h);
    if (r.statusCode >= 300) throw 'Could not load doctors';
    return (jsonDecode(r.body) as List).map((e) => Doctor.fromJson(e)).toList();
  }

  static Future<void> book(String spec, String doctorId, String serviceType) async {
    final r = await http.post(Uri.parse('$baseUrl/bookings'),
        headers: _h,
        body: jsonEncode({
          'userId': userId,
          'specialization': spec,
          'doctorId': doctorId,
          'serviceType': serviceType,
          'timestamp': DateTime.now().toIso8601String(),
        }));
    if (r.statusCode >= 300) throw jsonDecode(r.body)['message'] ?? 'Booking failed';
  }
}
