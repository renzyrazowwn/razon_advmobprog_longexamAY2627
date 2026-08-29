import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/post_service.dart';
import '../services/user_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_dialogs.dart';
import '../widgets/custom_font.dart';
import '../widgets/custom_info.dart';
import '../widgets/post_card.dart';

class ProfileScreen extends StatefulWidget {
  final String username;
  final int userId;

  const ProfileScreen({
    super.key,
    required this.username,
    required this.userId,
  });

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {
  final UserService _userService =
      UserService();

  final PostService _postService =
      PostService();

  User? _user;
  List<Post> _posts = [];

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await Future.wait([
        _userService.getUserById(widget.userId),
        _postService.getPostsByUser(widget.userId),
      ]);

      if (!mounted) return;

      setState(() {
        _user = results[0] as User;
        _posts = results[1] as List<Post>;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _error = 'Failed to load profile.';
      });
    }
  }

  ImageProvider? _imageProvider(
    String image,
  ) {
    if (image.isEmpty) return null;

    if (image.startsWith('http')) {
      return CachedNetworkImageProvider(
        image,
      );
    }

    return AssetImage(image);
  }

  Widget _buildPosts() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: PEACE_PRIMARY,
        ),
      );
    }

    if (_error != null) {
      return CustomInfo.error(
        message: _error!,
        onAction: _loadProfile,
      );
    }

    if (_posts.isEmpty) {
      return const CustomInfo.empty(
        message: 'No posts yet.',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadProfile,
      child: ListView.builder(
        padding: EdgeInsets.all(10.w),
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];

          return PostCard(
            postId: post.id,
            userName:
                _user?.username ??
                    widget.username,
            postContent: post.body,
            numOfLikes: post.likes,
            date: 'Public',
            profileImageUrl:
                _user?.image ?? '',
          );
        },
      ),
    );
  }

  Widget _aboutRow(
    IconData icon,
    String text,
  ) {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20.sp,
            color: Theme.of(context)
                .iconTheme
                .color,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }

  Widget _photos() {
    final photos = [
      'https://picsum.photos/400/400?1',
      'https://picsum.photos/400/400?2',
      'https://picsum.photos/400/400?3',
      'https://picsum.photos/400/400?4',
    ];

    return GridView.builder(
      padding: EdgeInsets.all(15.w),
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: photos.length,
      itemBuilder: (_, index) {
        return GestureDetector(
          onTap: () {
            customShowImageDialog(
              context,
              imageUrl: photos[index],
            );
          },
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(8),
            child: Image.network(
              photos[index],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor:
            Theme.of(context)
                .scaffoldBackgroundColor,

        body: NestedScrollView(
          headerSliverBuilder:
              (context, _) {
            return [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Stack(
                      clipBehavior:
                          Clip.none,
                      children: [
                        Container(
                          height: 200.h,
                          decoration:
                              const BoxDecoration(
                            image:
                                DecorationImage(
                              image: NetworkImage(
                                'https://picsum.photos/900/400',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: -50,
                          left: 20.w,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                _imageProvider(
                              user?.image ?? '',
                            ),
                            child: user?.image
                                        .isEmpty ??
                                    true
                                ? const Icon(
                                    Icons.person,
                                    size: 45,
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 60.h),

                    Padding(
                      padding:
                          EdgeInsets.symmetric(
                        horizontal: 20.w,
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          CustomFont(
                            text:
                                user?.fullName ??
                                    widget.username,
                            fontSize: 20.sp,
                            fontWeight:
                                FontWeight.bold,
                            color:
                                Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .color!,
                          ),

                          SizedBox(height: 4.h),

                          Text(
                            '@${user?.username ?? widget.username}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.sp,
                            ),
                          ),

                          SizedBox(height: 10.h),

                          Row(
                            children: [
                              CustomButton(
                                buttonName:
                                    'Follow',
                                onPressed: () {},
                              ),
                              SizedBox(width: 10.w),
                              CustomButton(
                                buttonName:
                                    'Message',
                                buttonType:
                                    'outlined',
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 15.h),
                  ],
                ),
              ),

              SliverPersistentHeader(
                pinned: true,
                delegate:
                    _SliverTabBarDelegate(
                  TabBar(
                    labelColor:
                        PEACE_PRIMARY,
                    unselectedLabelColor:
                        Colors.grey,
                    indicatorColor:
                        PEACE_PRIMARY,
                    tabs: const [
                      Tab(text: 'Posts'),
                      Tab(text: 'About'),
                      Tab(text: 'Photos'),
                    ],
                  ),
                ),
              ),
            ];
          },

          body: TabBarView(
            children: [
              _buildPosts(),

              SingleChildScrollView(
                padding:
                    EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    _aboutRow(
                      Icons.email,
                      user?.email ?? '',
                    ),
                    _aboutRow(
                      Icons.phone,
                      user?.phone ?? '',
                    ),
                    _aboutRow(
                      Icons.person,
                      user?.gender ?? '',
                    ),
                  ],
                ),
              ),

              SingleChildScrollView(
                child: _photos(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverTabBarDelegate
    extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context)
          .scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  double get maxExtent =>
      tabBar.preferredSize.height;

  @override
  double get minExtent =>
      tabBar.preferredSize.height;

  @override
  bool shouldRebuild(
    covariant _SliverTabBarDelegate
        oldDelegate,
  ) {
    return false;
  }
}