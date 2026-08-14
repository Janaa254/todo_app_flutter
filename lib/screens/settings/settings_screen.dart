import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/colors/app_colors.dart';
import '../../providers/theme_provider.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});


  Future<void> _changeLanguage(
      BuildContext context,
      Locale locale,
      ) async {
    await context.setLocale(locale);
  }


  Future<void> _logout(
      BuildContext context,
      ) async {
    final shouldLogout =
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'logout'.tr(),
          ),

          content: Text(
            'logout_confirmation'.tr(),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: Text(
                'cancel'.tr(),
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },

              style: TextButton.styleFrom(
                foregroundColor:
                Colors.red,
              ),

              child: Text(
                'logout'.tr(),
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) {
      return;
    }


    final prefs =
    await SharedPreferences
        .getInstance();

    await prefs.setBool(
      'is_logged_in',
      false,
    );

    if (!context.mounted) {
      return;
    }


    Navigator.pushAndRemoveUntil(
      context,

      MaterialPageRoute(
        builder: (_) =>
        const LoginScreen(),
      ),

          (route) => false,
    );
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    final currentLocale =
        context.locale;

    final themeProvider =
    context.watch<ThemeProvider>();

    final isDark =
        themeProvider.isDarkMode;

    return Scaffold(

      appBar: AppBar(
        title: Text(
          'settings'.tr(),

          style: const TextStyle(
            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),


      body: ListView(
        padding:
        const EdgeInsets.all(20),

        children: [

          Text(
            'language'.tr(),

            style: const TextStyle(
              fontSize: 18,
              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),


          Container(
            decoration: BoxDecoration(
              color:
              Theme.of(context)
                  .cardColor,

              borderRadius:
              BorderRadius.circular(
                18,
              ),
            ),

            child: Column(
              children: [

                RadioListTile<Locale>(
                  value:
                  const Locale('en'),

                  groupValue:
                  currentLocale,

                  activeColor:
                  AppColors.primary,

                  secondary:
                  const Icon(
                    Icons
                        .language_outlined,
                  ),

                  title: Text(
                    'english'.tr(),
                  ),

                  onChanged: (locale) {
                    if (locale != null) {
                      _changeLanguage(
                        context,
                        locale,
                      );
                    }
                  },
                ),

                const Divider(
                  height: 1,
                ),


                RadioListTile<Locale>(
                  value:
                  const Locale('ar'),

                  groupValue:
                  currentLocale,

                  activeColor:
                  AppColors.primary,

                  secondary:
                  const Icon(
                    Icons
                        .translate_outlined,
                  ),

                  title: Text(
                    'arabic'.tr(),
                  ),

                  onChanged: (locale) {
                    if (locale != null) {
                      _changeLanguage(
                        context,
                        locale,
                      );
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),


          Text(
            'appearance'.tr(),

            style: const TextStyle(
              fontSize: 18,
              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),


          Container(
            decoration: BoxDecoration(
              color:
              Theme.of(context)
                  .cardColor,

              borderRadius:
              BorderRadius.circular(
                18,
              ),
            ),

            child: Column(
              children: [

                RadioListTile<bool>(
                  value: false,

                  groupValue: isDark,

                  activeColor:
                  AppColors.primary,

                  secondary:
                  const Icon(
                    Icons
                        .light_mode_outlined,
                  ),

                  title: Text(
                    'light_mode'.tr(),
                  ),

                  onChanged: (value) {
                    if (value != null) {
                      context
                          .read<
                          ThemeProvider>()
                          .toggleTheme(
                        value,
                      );
                    }
                  },
                ),

                const Divider(
                  height: 1,
                ),


                RadioListTile<bool>(
                  value: true,

                  groupValue: isDark,

                  activeColor:
                  AppColors.primary,

                  secondary:
                  const Icon(
                    Icons
                        .dark_mode_outlined,
                  ),

                  title: Text(
                    'dark_mode'.tr(),
                  ),

                  onChanged: (value) {
                    if (value != null) {
                      context
                          .read<
                          ThemeProvider>()
                          .toggleTheme(
                        value,
                      );
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),


          Text(
            'account'.tr(),

            style: const TextStyle(
              fontSize: 18,
              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),


          Container(
            decoration: BoxDecoration(
              color:
              Theme.of(context)
                  .cardColor,

              borderRadius:
              BorderRadius.circular(
                18,
              ),
            ),

            child: ListTile(
              leading: const Icon(
                Icons.logout_rounded,
                color: Colors.red,
              ),

              title: Text(
                'logout'.tr(),

                style:
                const TextStyle(
                  color: Colors.red,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),

              trailing: const Icon(
                Icons
                    .arrow_forward_ios_rounded,

                size: 17,

                color: Colors.red,
              ),

              onTap: () {
                _logout(context);
              },
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}