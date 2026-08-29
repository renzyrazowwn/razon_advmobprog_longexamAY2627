import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/post_service.dart';
import '../services/user_service.dart';
import '../widgets/custom_info.dart';
import '../widgets/post_card.dart';

// EDIT FIX Enhancement 2 / 3: This file previously contained a duplicate
// copy of HomeScreen (now correctly restored to screens/home_screen.dart),
// so NewsFeedScreen — which home_screen.dart already tries to instantiate —
// did not exist and the app could not compile. Rebuilt as the actual feed
// screen: it loads posts from GET /posts and renders each one with
// PostCard, which is what carries the Enhancement 3 like/comment behavior.
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

  List<Post> _posts = [];

  // Cache of author id -> author, so each post can show the poster's real
  // name (and avatar) instead of a generic "User #id" placeholder.
  final Map<int, User> _usersById = {};

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

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

      // Fetch author details for every distinct poster on this page of
      // posts, in parallel, then merge them in as they arrive so names
      // fill in without blocking the initial post list from showing.
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
