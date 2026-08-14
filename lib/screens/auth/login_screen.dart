import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/colors/app_colors.dart';
import '../home/home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }



  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();

    final savedEmail = prefs.getString('user_email');
    final savedPassword =
    prefs.getString('user_password');

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (!mounted) return;

    if (savedEmail == null || savedPassword == null) {
      setState(() {
        _isLoading = false;
      });

      _showError(
        'no_account'.tr(),
      );

      return;
    }

    if (email != savedEmail ||
        password != savedPassword) {
      setState(() {
        _isLoading = false;
      });

      _showError(
        'invalid_login'.tr(),
      );

      return;
    }

    await prefs.setBool(
      'is_logged_in',
      true,
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
    );
  }



  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),

          backgroundColor: Colors.red,

          behavior:
          SnackBarBehavior.floating,

          margin: const EdgeInsets.all(16),

          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(12),
          ),
        ),
      );
  }



  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'enter_email'.tr();
    }

    final emailRegex = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'invalid_email'.tr();
    }

    return null;
  }



  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'enter_password'.tr();
    }

    if (value.length < 6) {
      return 'password_short'.tr();
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      AppColors.lightBackground,

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 28,
            ),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.stretch,

                children: [


                  Container(
                    width: 90,
                    height: 90,

                    decoration: BoxDecoration(
                      color: AppColors.primary,

                      borderRadius:
                      BorderRadius.circular(25),
                    ),

                    child: const Icon(
                      Icons.task_alt_rounded,
                      color: Colors.white,
                      size: 52,
                    ),
                  ),

                  const SizedBox(height: 25),



                  Text(
                    'welcome_back'.tr(),

                    textAlign:
                    TextAlign.center,

                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'login_subtitle'.tr(),

                    textAlign:
                    TextAlign.center,

                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 35),



                  Text(
                    'email'.tr(),

                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller:
                    _emailController,

                    keyboardType:
                    TextInputType.emailAddress,

                    textInputAction:
                    TextInputAction.next,

                    validator:
                    _validateEmail,

                    decoration:
                    InputDecoration(
                      hintText:
                      'enter_email_hint'.tr(),

                      prefixIcon:
                      const Icon(
                        Icons.email_outlined,
                      ),

                      filled: true,

                      fillColor:
                      Theme.of(context)
                          .cardColor,

                      border:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(
                          15,
                        ),

                        borderSide:
                        BorderSide.none,
                      ),

                      enabledBorder:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(
                          15,
                        ),

                        borderSide:
                        BorderSide.none,
                      ),

                      focusedBorder:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(
                          15,
                        ),

                        borderSide:
                        BorderSide(
                          color:
                          AppColors.primary,
                          width: 1.5,
                        ),
                      ),

                      errorBorder:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(
                          15,
                        ),

                        borderSide:
                        const BorderSide(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),



                  Text(
                    'password'.tr(),

                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller:
                    _passwordController,

                    obscureText:
                    _obscurePassword,

                    textInputAction:
                    TextInputAction.done,

                    validator:
                    _validatePassword,

                    onFieldSubmitted: (_) {
                      _login();
                    },

                    decoration:
                    InputDecoration(
                      hintText:
                      'enter_password_hint'
                          .tr(),

                      prefixIcon:
                      const Icon(
                        Icons.lock_outline,
                      ),



                      suffixIcon:
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword =
                            !_obscurePassword;
                          });
                        },

                        icon: Icon(
                          _obscurePassword
                              ? Icons
                              .visibility_off_outlined
                              : Icons
                              .visibility_outlined,
                        ),
                      ),

                      filled: true,

                      fillColor:
                      Theme.of(context)
                          .cardColor,

                      border:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(
                          15,
                        ),

                        borderSide:
                        BorderSide.none,
                      ),

                      enabledBorder:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(
                          15,
                        ),

                        borderSide:
                        BorderSide.none,
                      ),

                      focusedBorder:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(
                          15,
                        ),

                        borderSide:
                        BorderSide(
                          color:
                          AppColors.primary,
                          width: 1.5,
                        ),
                      ),

                      errorBorder:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(
                          15,
                        ),

                        borderSide:
                        const BorderSide(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),



                  SizedBox(
                    height: 55,

                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : _login,

                      style:
                      ElevatedButton.styleFrom(
                        backgroundColor:
                        AppColors.primary,

                        foregroundColor:
                        Colors.white,

                        elevation: 0,

                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                            15,
                          ),
                        ),
                      ),

                      child: _isLoading
                          ? const SizedBox(
                        width: 23,
                        height: 23,

                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color:
                          Colors.white,
                        ),
                      )
                          : Text(
                        'login'.tr(),

                        style:
                        const TextStyle(
                          fontSize: 17,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),



                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: [
                      Text(
                        'dont_have_account'
                            .tr(),

                        style:
                        const TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const SignUpScreen(),
                            ),
                          );
                        },

                        child: Text(
                          'signup'.tr(),

                          style:
                          TextStyle(
                            color:
                            AppColors.primary,

                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}