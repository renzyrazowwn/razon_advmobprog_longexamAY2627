import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/custom_notification.dart' as notif;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState
    extends State<NotificationScreen> {
  final List<Map<String, String>> notifications = [
    {
      'name': 'Lori Aquino',
      'post': 'hbd to me ito po gcash ko 09123456789',
      'description': 'Posted a new status.',
      'image': 'assets/icons/aquino.jpeg',
      'date': 'December 11',
      'likes': '12',
    },
    {
      'name': 'KC Yabut',
      'post': 'ANG LAMIG',
      'description': 'Posted a new status.',
      'image': 'assets/icons/yabut.jpeg',
      'date': 'December 1',
      'likes': '2',
    },
    {
      'name': 'Pau Miraflor',
      'post': 'magchristmas break lang talaga',
      'description': 'Shared your post.',
      'image': 'assets/icons/miraflor.jpeg',
      'date': 'December 9',
      'likes': '28',
    },
    {
      'name': 'Loi Puducay',
      'post': 'with my bffs <3',
      'description':
          'Posted a new status with you and 3 others.',
      'image': 'assets/icons/puducay.jpeg',
      'date': 'December 15',
      'likes': '50',
    },
    {
      'name': 'Lori Aquino',
      'post': 'GRABE KA NA 2026',
      'description': 'Posted a new status.',
      'image': 'assets/icons/aquino.jpeg',
      'date': 'December 10',
      'likes': '20',
    },
    {
      'name': 'Pau Miraflor',
      'post': '@followers paload ako pls',
      'description': 'Posted a new status.',
      'image': 'assets/icons/miraflor.jpeg',
      'date': 'December 25',
      'likes': '25',
    },
    {
      'name': 'Lori Aquino',
      'post': 'happy birthday to me i guess',
      'description': 'Posted a new status.',
      'image': 'assets/icons/aquino.jpeg',
      'date': 'December 3',
      'likes': '10',
    },
    {
      'name': 'KC Yabut',
      'post': 'kulang lang pala sa ;',
      'description': 'Posted a new status.',
      'image': 'assets/icons/yabut.jpeg',
      'date': 'December 30',
      'likes': '40',
    },
    {
      'name': 'Pau Miraflor',
      'post': 'PALOAD AKO PLS',
      'description': 'Posted a new status.',
      'image': 'assets/icons/miraflor.jpeg',
      'date': 'December 12',
      'likes': '45',
    },
    {
      'name': 'Loi Puducay',
      'post': 'LF pastil',
      'description': 'Posted a new status.',
      'image': 'assets/icons/puducay.jpeg',
      'date': 'December 31',
      'likes': '100',
    },
  ];

 @override
Widget build(BuildContext context) {
  return Container(
    color: Theme.of(context)
        .scaffoldBackgroundColor,
    width: double.infinity,
    child: ListView.separated(
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
      ),
      itemCount: notifications.length,
      separatorBuilder: (_, __) {
        return Divider(
          color: Theme.of(context)
              .dividerColor,
        );
      },
      itemBuilder: (context, index) {
        final item =
            notifications[index];

        return notif.CustomNotification(
          name: item['name']!,
          post: item['post']!,
          description:
              item['description']!,
          profileImageUrl:
              item['image']!,
          date: item['date']!,
          numOfLikes:
              int.parse(item['likes']!),
        );
      },
    ),
  );
}
}