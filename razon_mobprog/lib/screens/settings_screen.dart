import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/theme_provider.dart';
import '../services/user_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _signOut(
    BuildContext context,
  ) async {
    final confirmed =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text(
            'Are you sure you want to sign out?',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(
                dialogContext,
                false,
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    PEACE_DARK_PRIMARY,
                foregroundColor:
                    Colors.white,
              ),
              onPressed: () =>
                  Navigator.pop(
                dialogContext,
                true,
              ),
              child:
                  const Text('Sign Out'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await UserService().logout();

    if (!context.mounted) return;

    // EDIT FIX Enhancement 2: main.dart only registers '/signin' and
    // '/splash' as named routes — '/login' does not exist, so tapping
    // Sign Out threw a "could not find a generator" error instead of
    // returning the user to the sign-in screen.
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/signin',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        context.watch<ThemeProvider>();

    final isDark =
        themeProvider.isDark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),

      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          Text(
            'Appearance',
            style: TextStyle(
              color: PEACE_PRIMARY,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8.h),

          Card(
            child: SwitchListTile(
              secondary: Icon(
                isDark
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              title:
                  const Text('Dark Mode'),
              subtitle: Text(
                isDark
                    ? 'Dark theme is enabled'
                    : 'Light theme is enabled',
              ),
              value: isDark,
              onChanged: (_) {
                themeProvider
                    .toggleTheme();
              },
            ),
          ),

          SizedBox(height: 25.h),

          Text(
            'Account',
            style: TextStyle(
              color: PEACE_PRIMARY,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8.h),

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'Sign out of your account',
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () =>
                  _signOut(context),
            ),
          ),
        ],
      ),
    );
  }
}