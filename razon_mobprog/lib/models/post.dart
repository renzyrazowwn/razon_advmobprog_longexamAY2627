class Post {
  final int id;
  final String title;
  final String body;
  final int userId;
  final int likes;
  final int dislikes;
  final int views;

  const Post({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    required this.likes,
    required this.dislikes,
    required this.views,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    final reactions = json['reactions'] as Map<String, dynamic>?;

    return Post(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      likes: (reactions?['likes'] as num?)?.toInt() ?? 0,
      dislikes: (reactions?['dislikes'] as num?)?.toInt() ?? 0,
      views: (json['views'] as num?)?.toInt() ?? 0,
    );
  }
}