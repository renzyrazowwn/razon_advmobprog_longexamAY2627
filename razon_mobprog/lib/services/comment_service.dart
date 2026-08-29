import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/comment.dart';

class CommentService {
  static const String baseUrl = host;

  Future<List<Comment>> getCommentsByPost(
    int postId,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/posts/$postId/comments',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load comments.');
    }

    final data = jsonDecode(response.body);

    final List<dynamic> comments =
        data['comments'] ?? [];

    return comments
        .map(
          (json) => Comment.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<Comment> addComment({
    required int postId,
    required String body,
    required int userId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/comments/add'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'body': body,
        'postId': postId,
        'userId': userId,
      }),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      throw Exception('Failed to add comment.');
    }

    return Comment.fromJson(
      jsonDecode(response.body),
    );
  }
}