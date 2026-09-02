import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'providers/theme_provider.dart';
import 'screens/signin_screen.dart';
import 'screens/splash_screen.dart';

// Enhancement 1 & 2
// wraps app root with ChangeNotifierProvider for global theme management
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

  // builds root application widget configuring theme and routes
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
          
          // Enhancement 1
          // launches splash screen first to verify saved session
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