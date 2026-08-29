import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/post.dart';

class PostService {
  static const String baseUrl = host;

  Future<List<Post>> getPosts({
    int limit = 30,
    int skip = 0,
  }) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/posts?limit=$limit&skip=$skip',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load posts.');
    }

    final data = jsonDecode(response.body);

    final List<dynamic> posts =
        data['posts'] ?? [];

    return posts
        .map(
          (json) => Post.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<List<Post>> getPostsByUser(
    int userId,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/users/$userId/posts',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load user posts.');
    }

    final data = jsonDecode(response.body);

    final List<dynamic> posts =
        data['posts'] ?? [];

    return posts
        .map(
          (json) => Post.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}