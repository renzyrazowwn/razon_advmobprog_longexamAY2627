import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import '../services/user_service.dart';
import '../widgets/custom_dialogs.dart';
import '../widgets/custom_font.dart';
import '../widgets/custom_inkwell_button.dart';
import '../widgets/custom_textformfield.dart';
import 'home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() =>
      _SignInScreenState();
}

class _SignInScreenState
    extends State<SignInScreen> {
  final GlobalKey<FormState> _loginFormKey =
      GlobalKey<FormState>();

  final TextEditingController
      usernameController =
      TextEditingController();

  final TextEditingController
      passwordController =
      TextEditingController();

  final UserService _userService =
      UserService();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_loginFormKey.currentState!
        .validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _userService.login(
        usernameController.text.trim(),
        passwordController.text,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (user == null) {
        customDialog(
          context,
          title: 'Login Failed',
          content:
              'Username or password is incorrect.',
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            username: user.username,
            userId: user.id,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      customDialog(
        context,
        title: 'Connection Error',
        content:
            'Unable to connect to DummyJSON. Please check your internet connection.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Scaffold(
      backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            height: ScreenUtil().screenHeight,
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40.h,
                  color: PEACE_DARK_PRIMARY,
                ),

                Padding(
                  padding:
                      EdgeInsets.symmetric(
                    horizontal: 25.w,
                  ),
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/logo.jpeg',
                          height: 200.h,
                        ),

                        SizedBox(height: 30.h),

                        CustomTextFormField(
                          controller:
                              usernameController,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Username is required';
                            }

                            return null;
                          },
                          onSaved: (_) {},
                          hintText: 'Username',
                          fontSize: 15.sp,
                          fontColor: isDark
                              ? Colors.white
                              : PEACE_DARK_PRIMARY,
                          height: 10.h,
                          width: 10.w,
                        ),

                        SizedBox(height: 18.h),

                        CustomTextFormField(
                          controller:
                              passwordController,
                          obscureText:
                              _obscurePassword,
                          hasToggle: true,
                          onToggle: () {
                            setState(() {
                              _obscurePassword =
                                  !_obscurePassword;
                            });
                          },
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty) {
                              return 'Password is required';
                            }

                            return null;
                          },
                          onSaved: (_) {},
                          hintText: 'Password',
                          fontSize: 15.sp,
                          fontColor: isDark
                              ? Colors.white
                              : PEACE_DARK_PRIMARY,
                          height: 10.h,
                          width: 10.w,
                        ),

                        SizedBox(height: 40.h),

                        SizedBox(
                          width: double.infinity,
                          height: 45.h,
                          child: _isLoading
                              ? const Center(
                                  child:
                                      CircularProgressIndicator(
                                    color:
                                        PEACE_PRIMARY,
                                  ),
                                )
                              : CustomInkwellButton(
                                  onTap: _login,
                                  height: 45.h,
                                  width:
                                      double.infinity,
                                  buttonName:
                                      'Login',
                                  fontSize: 15.sp,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  height: 45.h,
                  color: PEACE_DARK_PRIMARY,
                  child: Center(
                    child: Text(
                      'Use a DummyJSON test account to log in.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}