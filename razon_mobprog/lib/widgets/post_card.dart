import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import '../screens/detail_screen.dart';
import 'custom_font.dart';

// EDIT FIX Enhancement 2 / 3: This file previously contained a duplicate
// copy of DetailScreen (now correctly restored to screens/detail_screen.dart).
// Rebuilt as the actual PostCard widget that profile_screen.dart
// (Enhancement 2 — posts rendered by userId) expects to import, with its
// own clickable Like button and a tap target that opens the full post with
// its comments (Enhancement 3) in DetailScreen.
class PostCard extends StatefulWidget {
  final int postId;
  final String userName;
  final String postContent;
  final int numOfLikes;
  final String date;
  final String profileImageUrl;
  final String imageUrl;

  const PostCard({
    super.key,
    required this.postId,
    required this.userName,
    required this.postContent,
    required this.numOfLikes,
    required this.date,
    this.profileImageUrl = '',
    this.imageUrl = '',
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late int _likes;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _likes = widget.numOfLikes;
  }

  // EDIT FIX Enhancement 3: clickable like button directly on the post
  // preview (not just inside DetailScreen), so tapping the newsfeed/profile
  // card updates likes immediately without opening the post.
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

  ImageProvider? _avatar(String image) {
    if (image.isEmpty) return null;

    if (image.startsWith('http')) {
      return CachedNetworkImageProvider(image);
    }

    return AssetImage(image);
  }

  void _openDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailScreen(
          postId: widget.postId,
          userName: widget.userName,
          postContent: widget.postContent,
          date: widget.date,
          numOfLikes: _likes,
          imageUrl: widget.imageUrl,
          profileImageUrl: widget.profileImageUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      child: InkWell(
        onTap: () => _openDetail(context),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: PEACE_LIGHT_PRIMARY,
                    backgroundImage: _avatar(widget.profileImageUrl),
                    child: widget.profileImageUrl.isEmpty
                        ? const Icon(
                            Icons.person,
                            color: PEACE_DARK_PRIMARY,
                          )
                        : null,
                  ),

                  SizedBox(width: 10.w),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomFont(
                          text: widget.userName,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .color!,
                        ),
                        CustomFont(
                          text: widget.date,
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.h),

              Text(
                widget.postContent,
                style: TextStyle(fontSize: 14.sp),
              ),

              if (widget.imageUrl.isNotEmpty) ...[
                SizedBox(height: 10.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ],

              SizedBox(height: 8.h),

              const Divider(height: 1),

              Row(
                children: [
                  Expanded(
                    // EDIT FIX Enhancement 3: like button is clickable and
                    // reflects the running like count.
                    child: TextButton.icon(
                      onPressed: _toggleLike,
                      icon: Icon(
                        _isLiked
                            ? Icons.thumb_up
                            : Icons.thumb_up_outlined,
                        size: 18,
                        color: _isLiked ? PEACE_PRIMARY : null,
                      ),
                      label: Text(
                        '$_likes',
                        style: TextStyle(
                          color: _isLiked ? PEACE_PRIMARY : null,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    // EDIT FIX Enhancement 3: opens DetailScreen so the
                    // user can read/add comments for this post.
                    child: TextButton.icon(
                      onPressed: () => _openDetail(context),
                      icon: const Icon(Icons.comment_outlined, size: 18),
                      label: const Text('Comment'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
