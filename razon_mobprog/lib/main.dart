import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'providers/theme_provider.dart';
import 'screens/signin_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const FacebookReplication(),
    ),
  );
}

class FacebookReplication extends StatelessWidget {
  const FacebookReplication({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return ScreenUtilInit(
      designSize: const Size(412, 715),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Facebook Replication',

          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,

          themeMode: themeProvider.isDark
              ? ThemeMode.dark
              : ThemeMode.light,

          // EDIT FIX Enhancement 1: the app must boot into SplashScreen so
          // it can check shared_preferences for a saved session and decide
          // whether to send the user to HomeScreen or SignInScreen. This
          // was hard-coded to '/signin', which skipped that check entirely
          // and meant a logged-in user had to sign in again every launch.
          initialRoute: '/splash',

          routes: {
            '/signin': (context) => const SignInScreen(),
            '/splash': (context) => const SplashScreen(),
          },
        );
      },
    );
  }
}