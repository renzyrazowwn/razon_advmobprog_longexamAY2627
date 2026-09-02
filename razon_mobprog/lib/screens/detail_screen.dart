import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import '../models/comment.dart';
import '../models/user.dart';
import '../services/comment_service.dart';
import '../services/user_service.dart';
import '../widgets/custom_info.dart';


class DetailScreen extends StatefulWidget {
  final int? postId;
  final String userName;
  final String postContent;
  final String date;
  final int numOfLikes;
  final String imageUrl;
  final String profileImageUrl;

  const DetailScreen({
    super.key,
    this.postId,
    this.userName = '',
    this.postContent = '',
    this.date = '',
    this.numOfLikes = 0,
    this.imageUrl = '',
    this.profileImageUrl = '',
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // Enhancement 3
  // tracks local like count for the current post
  late int _likes;

  bool _isLiked = false;
  bool _loadingComments = true;
  bool _sendingComment = false;

  String? _commentError;

  final TextEditingController _commentController = TextEditingController();

  final CommentService _commentService = CommentService();
  final UserService _userService = UserService();

  final List<Comment> _comments = [];

  final Set<int> _likedComments = {};

// Enhancement 1
// holds currently authenticated user session
  User? _currentUser;

  @override
  void initState() {
    super.initState();

    _likes = widget.numOfLikes;

    _loadUser();
    _loadComments();
  }

// Enhancement 1
// retrieves saved logged-in user from shared preferences
  Future<void> _loadUser() async {
    final user = await _userService.getSavedUser();

    if (!mounted) return;

    setState(() {
      _currentUser = user;
    });
  }

// Enhancement 3
// fetches comments belonging to current post ID from API
  Future<void> _loadComments() async {
    if (widget.postId == null) {
      setState(() {
        _loadingComments = false;
        _commentError = 'Comments are not available for this post.';
      });
      return;
    }

    setState(() {
      _loadingComments = true;
      _commentError = null;
    });

    try {
      final comments =
          await _commentService.getCommentsByPost(widget.postId!);

      if (!mounted) return;

      setState(() {
        _comments
          ..clear()
          ..addAll(comments);

        _loadingComments = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loadingComments = false;
        _commentError = 'Failed to load comments.';
      });
    }
  }

// Enhancement 3
// toggles post like button and updates count using setState
  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;

      if (_isLiked) {
        _likes++;
      } else if (_likes > 0) {
        _likes--;
      }
    });
  }

  void _toggleCommentLike(int commentId) {
    setState(() {
      if (_likedComments.contains(commentId)) {
        _likedComments.remove(commentId);
      } else {
        _likedComments.add(commentId);
      }
    });
  }

// Enhancement 3
// posts new comment to dummyjson API
  Future<void> _addComment() async {
    final text = _commentController.text.trim();

    if (text.isEmpty || widget.postId == null || _sendingComment) {
      return;
    }

    final user = _currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be signed in to comment.'),
        ),
      );
      return;
    }

    setState(() {
      _sendingComment = true;
    });

    try {
      final comment = await _commentService.addComment(
        postId: widget.postId!,
        body: text,
        userId: user.id,
      );

      if (!mounted) return;

      setState(() {
        _comments.insert(0, comment);
        _sendingComment = false;
      });

      _commentController.clear();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _sendingComment = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to add comment.'),
        ),
      );
    }
  }

  ImageProvider? _avatar(String image) {
    if (image.isEmpty) return null;

    if (image.startsWith('http')) {
      return CachedNetworkImageProvider(image);
    }

    return AssetImage(image);
  }

// Enhancement 3
// builds comment list item with clickable like button
  Widget _buildComment(Comment comment) {
    final isLiked = _likedComments.contains(comment.id);
    final displayedLikes = comment.likes + (isLiked ? 1 : 0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: PEACE_LIGHT_PRIMARY,
            child: const Icon(
              Icons.person,
              color: PEACE_DARK_PRIMARY,
            ),
          ),

          SizedBox(width: 10.w),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.fullName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 3.h),

                  Text(comment.body),

                  SizedBox(height: 4.h),

                  // Enhancement 3
                  // renders clickable like button for comment
                  InkWell(
                    onTap: () => _toggleCommentLike(comment.id),
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 2,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isLiked
                                ? Icons.thumb_up
                                : Icons.thumb_up_outlined,
                            size: 14,
                            color: isLiked ? PEACE_PRIMARY : Colors.grey,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '$displayedLikes',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: isLiked ? PEACE_PRIMARY : Colors.grey,
                              fontWeight: isLiked
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

// Enhancement 3
// renders comment section states including loading and empty
  Widget _buildComments() {
    if (_loadingComments) {
      return const Padding(
        padding: EdgeInsets.all(30),
        child: Center(
          child: CircularProgressIndicator(color: PEACE_PRIMARY),
        ),
      );
    }

    if (_commentError != null) {
      return CustomInfo.error(
        message: _commentError!,
        onAction: _loadComments,
      );
    }

    if (_comments.isEmpty) {
      return const CustomInfo.empty(message: 'No comments yet.');
    }

    return Column(
      children: _comments.map(_buildComment).toList(),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadComments,
              child: ListView(
                children: [
                  if (widget.imageUrl.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),

                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: _avatar(widget.profileImageUrl),
                          child: widget.profileImageUrl.isEmpty
                              ? const Icon(Icons.person)
                              : null,
                        ),

                        SizedBox(width: 10.w),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.userName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                widget.date,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      widget.postContent,
                      style: TextStyle(fontSize: 15.sp),
                    ),
                  ),

                  SizedBox(height: 15.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      '$_likes likes',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),

                  const Divider(),

                  Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: _toggleLike,
                          icon: Icon(
                            _isLiked
                                ? Icons.thumb_up
                                : Icons.thumb_up_outlined,
                            color: _isLiked ? PEACE_PRIMARY : null,
                          ),
                          label: Text(
                            'Like',
                            style: TextStyle(
                              color: _isLiked ? PEACE_PRIMARY : null,
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {
                            FocusScope.of(context).requestFocus(
                              FocusNode(),
                            );
                          },
                          icon: const Icon(Icons.comment_outlined),
                          label: const Text('Comment'),
                        ),
                      ),
                    ],
                  ),

                  const Divider(),

                  Padding(
                    padding: EdgeInsets.all(15.w),
                    child: Text(
                      'Comments',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  _buildComments(),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border(
                  top: BorderSide(color: Theme.of(context).dividerColor),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      enabled: !_sendingComment,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _addComment(),
                      decoration: const InputDecoration(
                        hintText: 'Write a comment...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  _sendingComment
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          onPressed: _addComment,
                          icon: const Icon(
                            Icons.send,
                            color: PEACE_PRIMARY,
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
