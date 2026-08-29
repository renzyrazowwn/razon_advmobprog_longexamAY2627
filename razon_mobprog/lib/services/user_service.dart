import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/user.dart';

class UserService {
  static const String baseUrl = host;

  Future<User?> login(
    String username,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
        'expiresInMins': 60,
      }),
    );

    if (response.statusCode != 200) {
      return null;
    }

    final data = jsonDecode(response.body);

    if (data is! Map<String, dynamic>) {
      return null;
    }

    final user = User.fromJson(data);

    await saveUser(user);

    return user;
  }

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('userId', user.id);
    await prefs.setString('username', user.username);
    await prefs.setString('email', user.email);
    await prefs.setString('firstName', user.firstName);
    await prefs.setString('lastName', user.lastName);
    await prefs.setString('gender', user.gender);
    await prefs.setString('image', user.image);
    await prefs.setString('phone', user.phone);
    await prefs.setInt('age', user.age);
    await prefs.setString('accessToken', user.accessToken);
    await prefs.setString('refreshToken', user.refreshToken);
  }

  Future<User?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getInt('userId');

    if (userId == null) {
      return null;
    }

    return User(
      id: userId,
      username: prefs.getString('username') ?? '',
      email: prefs.getString('email') ?? '',
      firstName: prefs.getString('firstName') ?? '',
      lastName: prefs.getString('lastName') ?? '',
      gender: prefs.getString('gender') ?? '',
      image: prefs.getString('image') ?? '',
      phone: prefs.getString('phone') ?? '',
      age: prefs.getInt('age') ?? 0,
      accessToken: prefs.getString('accessToken') ?? '',
      refreshToken: prefs.getString('refreshToken') ?? '',
    );
  }

  Future<User> getUserById(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load user.');
    }

    return User.fromJson(
      jsonDecode(response.body),
    );
  }

  Future<User?> getCurrentUser() async {
    final savedUser = await getSavedUser();

    if (savedUser == null ||
        savedUser.accessToken.isEmpty) {
      return null;
    }

    final response = await http.get(
      Uri.parse('$baseUrl/user/me'),
      headers: {
        'Authorization':
            'Bearer ${savedUser.accessToken}',
      },
    );

    if (response.statusCode != 200) {
      return savedUser;
    }

    return User.fromJson(
      jsonDecode(response.body),
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }
}