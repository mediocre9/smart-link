import 'dart:convert';
import 'dart:developer';

import 'package:badges/badges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:smart_link/config/config.dart';
import 'package:smart_link/screens/keys_configuration_screen.dart';
import 'package:smart_link/screens/privacy_policy_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _updateAvailable = false;

  @override
  void initState() {
    super.initState();
    _isUpdateAvailable().then((_) {});
  }

  Future<void> _setUpdateAvailable(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("update_available", status);
  }

  Future<void> _isUpdateAvailable() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _updateAvailable = prefs.getBool("update_available") ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SettingsList(
        darkTheme: const SettingsThemeData(
          settingsSectionBackground: AppColors.scaffold,
          settingsListBackground: AppColors.scaffold,
          tileDescriptionTextColor: Colors.grey,
        ),
        sections: [
          SettingsSection(
            title: const Text('Configuration'),
            tiles: [
              SettingsTile.navigation(
                title: const Text('Keys Configuration'),
                leading: const Icon(Icons.tune_rounded),
                description: const Text("Customize commands"),
                trailing: const Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Colors.grey,
                ),
                onPressed: (BuildContext context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KeysConfigurationScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Account'),
            tiles: [
              SettingsTile.navigation(
                title: const Text('Sign out'),
                leading: const Icon(Icons.logout),
                description: Text(
                  FirebaseAuth.instance.currentUser?.email ?? "email",
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Colors.grey,
                ),
                onPressed: (BuildContext context) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Sign Out"),
                        content:
                            const Text("Are you sure you want to sign out?"),
                        actions: [
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text("Sign Out"),
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              await GoogleSignIn().disconnect();

                              if (context.mounted) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  AppRoutes.auth,
                                  (context) => false,
                                );
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Support'),
            tiles: [
              SettingsTile.navigation(
                title: const Text('Feedback & Suggestions'),
                description:
                    const Text("Report any issues or provide feedback."),
                trailing: const Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Colors.grey,
                ),
                leading: const Icon(Icons.bug_report_rounded),
                onPressed: (BuildContext context) {
                  Navigator.pushNamed(context, AppRoutes.feedback);
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Misc'),
            tiles: [
              SettingsTile(
                title: _updateAvailable
                    ? const Text("Update Available")
                    : const Text('Check for Updates'),
                description:
                    const Text("Current Version ${AppStrings.appVersion}"),
                leading: _updateAvailable
                    ? const Badge(
                        badgeStyle: BadgeStyle(
                          shape: BadgeShape.circle,
                          badgeColor: Colors.orange,
                        ),
                        child: Icon(
                          Icons.cloud_download_rounded,
                        ),
                      )
                    : const Icon(
                        Icons.cloud_download_rounded,
                      ),
                onPressed: (context) {
                  http.get(
                    Uri.parse(
                      "https://api.github.com/repos/mediocre9/smart-link/releases/latest",
                    ),
                    headers: {
                      "Accept": "application/vnd.github.v3+json",
                    },
                  ).then((response) {
                    if (response.statusCode == 200) {
                      dynamic json = jsonDecode(response.body);
                      String latestVersion =
                          json["tag_name"].toString().substring(1);
                      String currentVersion =
                          AppStrings.appVersion.substring(1);

                      if (latestVersion.compareTo(currentVersion) > 0) {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("New Version Available"),
                              content: Text(
                                '''A new version of Smart Link is available! Version v$latestVersion is now available, you have v$currentVersion.
                                \nYou are about to download an APK file from our official GitHub repository. Your browser might say the file is harmful, but it is safe. You can go ahead and download it.''',
                              ),
                              actions: [
                                TextButton(
                                  child: const Text("Update Now"),
                                  onPressed: () {
                                    final url = json["assets"][0]
                                        ["browser_download_url"];
                                    launchUrl(Uri.parse(url)).then((_) => {});
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _updateAvailable = true;
                                      _setUpdateAvailable(_updateAvailable);
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: const Text("Later"),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("No Updates Available"),
                              content: const Text("Your app is up to date."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _updateAvailable = false;
                                      _setUpdateAvailable(_updateAvailable);
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: const Text("Ok"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  }).catchError((error) {
                    log("Error fetching data: $error");
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Error"),
                          content: const Text(
                              "An error occurred while checking for updates."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Ok"),
                            ),
                          ],
                        );
                      },
                    );
                  });
                },
              ),
              SettingsTile.navigation(
                title: const Text('Contribute to Project'),
                description: const Text("Contribute to the project on GitHub"),
                leading: const Icon(SimpleIcons.github),
                onPressed: (BuildContext context) async {
                  await launchUrl(
                    Uri.parse("https://github.com/mediocre9/smart-link"),
                  );
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Legal'),
            tiles: [
              SettingsTile.navigation(
                title: const Text('Privacy Policy'),
                description: const Text("Review the privacy policy"),
                leading: const Icon(Icons.description),
                onPressed: (BuildContext context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyScreen(),
                    ),
                  );
                },
              ),
              SettingsTile.navigation(
                title: const Text('Licenses'),
                description: const Text("View licenses for used libraries"),
                leading: const Icon(Icons.collections_bookmark),
                onPressed: (context) {
                  showLicensePage(context: context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
