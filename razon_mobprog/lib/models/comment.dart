class Comment {
  final int id;
  final String body;
  final int postId;
  final int likes;
  final int userId;
  final String username;
  final String fullName;

  const Comment({
    required this.id,
    required this.body,
    required this.postId,
    required this.likes,
    required this.userId,
    required this.username,
    required this.fullName,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? {};

    return Comment(
      id: (json['id'] as num?)?.toInt() ?? 0,
      body: json['body']?.toString() ?? '',
      postId: (json['postId'] as num?)?.toInt() ?? 0,
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      userId: (user['id'] as num?)?.toInt() ?? 0,
      username: user['username']?.toString() ?? '',
      fullName: user['fullName']?.toString() ?? 'User',
    );
  }
}