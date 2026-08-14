import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/colors/app_colors.dart';
import '../home/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() =>
      _SignUpScreenState();
}

class _SignUpScreenState
    extends State<SignUpScreen> {
  final _formKey =
  GlobalKey<FormState>();

  final TextEditingController
  _nameController =
  TextEditingController();

  final TextEditingController
  _emailController =
  TextEditingController();

  final TextEditingController
  _passwordController =
  TextEditingController();

  final TextEditingController
  _confirmPasswordController =
  TextEditingController();

  bool _obscurePassword = true;

  bool _obscureConfirmPassword = true;

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }



  Future<void> _signUp() async {
    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final prefs =
    await SharedPreferences
        .getInstance();

    final name =
    _nameController.text.trim();

    final email =
    _emailController.text.trim();

    final password =
        _passwordController.text;

    await prefs.setString(
      'user_name',
      name,
    );

    await prefs.setString(
      'user_email',
      email,
    );

    await prefs.setString(
      'user_password',
      password,
    );

    await prefs.setBool(
      'is_logged_in',
      true,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    Navigator.pushAndRemoveUntil(
      context,

      MaterialPageRoute(
        builder: (_) =>
        const HomeScreen(),
      ),

          (route) => false,
    );
  }


  String? _validateEmail(
      String? value,
      ) {
    final email =
        value?.trim() ?? '';

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


  String? _validatePassword(
      String? value,
      ) {
    if (value == null ||
        value.isEmpty) {
      return 'enter_password'.tr();
    }

    if (value.length < 6) {
      return 'password_short'.tr();
    }

    return null;
  }


  String? _validateConfirmPassword(
      String? value,
      ) {
    if (value == null ||
        value.isEmpty) {
      return 'confirm_password'.tr();
    }

    if (value !=
        _passwordController.text) {
      return 'passwords_not_match'.tr();
    }

    return null;
  }



  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,

      prefixIcon: Icon(icon),

      suffixIcon: suffixIcon,

      filled: true,

      fillColor:
      Theme.of(context).cardColor,

      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(15),

        borderSide:
        BorderSide.none,
      ),

      enabledBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(15),

        borderSide:
        BorderSide.none,
      ),

      focusedBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(15),

        borderSide: BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),

      errorBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(15),

        borderSide:
        const BorderSide(
          color: Colors.red,
        ),
      ),

      focusedErrorBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(15),

        borderSide:
        const BorderSide(
          color: Colors.red,
        ),
      ),
    );
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    return Scaffold(
      backgroundColor:
      AppColors.lightBackground,

      appBar: AppBar(
        backgroundColor:
        AppColors.lightBackground,

        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),

        title: Text(
          'signup'.tr(),

          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 15,
            ),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .stretch,

                children: [


                  Container(
                    width: 75,
                    height: 75,

                    decoration:
                    BoxDecoration(
                      color:
                      AppColors.primary,

                      borderRadius:
                      BorderRadius.circular(
                        22,
                      ),
                    ),

                    child: const Icon(
                      Icons
                          .person_add_alt_1_rounded,

                      color: Colors.white,

                      size: 40,
                    ),
                  ),

                  const SizedBox(
                    height: 22,
                  ),



                  Text(
                    'create_account'.tr(),

                    textAlign:
                    TextAlign.center,

                    style:
                    const TextStyle(
                      fontSize: 27,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    'signup_subtitle'.tr(),

                    textAlign:
                    TextAlign.center,

                    style:
                    const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(
                    height: 28,
                  ),


                  Text(
                    'name'.tr(),

                    style:
                    const TextStyle(
                      fontSize: 15,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  TextFormField(
                    controller:
                    _nameController,

                    textInputAction:
                    TextInputAction.next,

                    validator: (value) {
                      if (value == null ||
                          value
                              .trim()
                              .isEmpty) {
                        return 'enter_name'
                            .tr();
                      }

                      return null;
                    },

                    decoration:
                    _inputDecoration(
                      hint:
                      'enter_name_hint'
                          .tr(),

                      icon:
                      Icons.person_outline,
                    ),
                  ),

                  const SizedBox(
                    height: 18,
                  ),



                  Text(
                    'email'.tr(),

                    style:
                    const TextStyle(
                      fontSize: 15,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  TextFormField(
                    controller:
                    _emailController,

                    keyboardType:
                    TextInputType
                        .emailAddress,

                    textInputAction:
                    TextInputAction.next,

                    validator:
                    _validateEmail,

                    decoration:
                    _inputDecoration(
                      hint:
                      'enter_email_hint'
                          .tr(),

                      icon:
                      Icons.email_outlined,
                    ),
                  ),

                  const SizedBox(
                    height: 18,
                  ),


                  Text(
                    'password'.tr(),

                    style:
                    const TextStyle(
                      fontSize: 15,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  TextFormField(
                    controller:
                    _passwordController,

                    obscureText:
                    _obscurePassword,

                    textInputAction:
                    TextInputAction.next,

                    validator:
                    _validatePassword,

                    decoration:
                    _inputDecoration(
                      hint:
                      'enter_password_hint'
                          .tr(),

                      icon:
                      Icons.lock_outline,



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
                    ),
                  ),

                  const SizedBox(
                    height: 18,
                  ),



                  Text(
                    'confirm_password_label'
                        .tr(),

                    style:
                    const TextStyle(
                      fontSize: 15,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  TextFormField(
                    controller:
                    _confirmPasswordController,

                    obscureText:
                    _obscureConfirmPassword,

                    textInputAction:
                    TextInputAction.done,

                    validator:
                    _validateConfirmPassword,

                    onFieldSubmitted: (_) {
                      _signUp();
                    },

                    decoration:
                    _inputDecoration(
                      hint:
                      'confirm_password_hint'
                          .tr(),

                      icon:
                      Icons.lock_outline,



                      suffixIcon:
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword =
                            !_obscureConfirmPassword;
                          });
                        },

                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons
                              .visibility_off_outlined
                              : Icons
                              .visibility_outlined,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 28,
                  ),


                  SizedBox(
                    height: 55,

                    child:
                    ElevatedButton(
                      onPressed:
                      _isLoading
                          ? null
                          : _signUp,

                      style:
                      ElevatedButton
                          .styleFrom(
                        backgroundColor:
                        AppColors.primary,

                        foregroundColor:
                        Colors.white,

                        elevation: 0,

                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .circular(
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
                          strokeWidth:
                          2.5,

                          color:
                          Colors.white,
                        ),
                      )
                          : Text(
                        'signup'.tr(),

                        style:
                        const TextStyle(
                          fontSize: 17,
                          fontWeight:
                          FontWeight
                              .bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 18,
                  ),



                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .center,

                    children: [
                      Text(
                        'already_have_account'
                            .tr(),

                        style:
                        const TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                          );
                        },

                        child: Text(
                          'login'.tr(),

                          style: TextStyle(
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