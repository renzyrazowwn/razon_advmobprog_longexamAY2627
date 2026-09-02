import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/post_service.dart';
import '../services/user_service.dart';
import '../widgets/custom_info.dart';
import '../widgets/post_card.dart';

class NewsFeedScreen extends StatefulWidget {
  final int userId;
  final String username;

  const NewsFeedScreen({
    super.key,
    required this.userId,
    required this.username,
  });

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  final PostService _postService = PostService();
  final UserService _userService = UserService();

  // Enhancement 2
  // holds loaded posts from dummyjson API
  List<Post> _posts = [];

  final Map<int, User> _usersById = {};

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  // Enhancement 2
  // fetches all posts from API
  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final posts = await _postService.getPosts();

      if (!mounted) return;

      setState(() {
        _posts = posts;
        _isLoading = false;
      });

      _loadAuthors(posts);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _error = 'Failed to load posts.';
      });
    }
  }

  Future<void> _loadAuthors(List<Post> posts) async {
    final missingIds = posts
        .map((post) => post.userId)
        .toSet()
        .where((id) => !_usersById.containsKey(id))
        .toList();

    if (missingIds.isEmpty) return;

    final results = await Future.wait(
      missingIds.map((id) async {
        try {
          return await _userService.getUserById(id);
        } catch (e) {
          return null;
        }
      }),
    );

    if (!mounted) return;

    setState(() {
      for (final user in results) {
        if (user != null) {
          _usersById[user.id] = user;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: PEACE_PRIMARY),
      );
    }

    if (_error != null) {
      return CustomInfo.error(
        message: _error!,
        onAction: _loadPosts,
      );
    }

    if (_posts.isEmpty) {
      return const CustomInfo.empty(message: 'No posts yet.');
    }

    return RefreshIndicator(
      onRefresh: _loadPosts,
      child: ListView.builder(
        padding: EdgeInsets.all(10.w),
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          final isCurrentUser = post.userId == widget.userId;
          final author = _usersById[post.userId];

          final displayName = isCurrentUser
              ? widget.username
              : (author?.fullName ?? 'User #${post.userId}');

          return PostCard(
            postId: post.id,
            userName: displayName,
            postContent: '${post.title}\n\n${post.body}',
            numOfLikes: post.likes,
            date: 'Public',
            profileImageUrl: author?.image ?? '',
          );
        },
      ),
    );
  }
}
