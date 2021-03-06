import 'package:buk/providers/initial/initial_provider.dart';
import 'package:buk/providers/screen/screen_provider.dart';
import 'package:buk/providers/settings_provider.dart';
import 'package:buk/providers/user_provider.dart';
import 'package:buk/screens/admin/verifications_screen.dart';
import 'package:buk/screens/blocked_users_screen.dart';
import 'package:buk/screens/feed_screen.dart';
import 'package:buk/widgets/settings/delete_dialog.dart';
import 'package:buk/widgets/translate/language_switch.dart';
import 'package:buk/widgets/translate/translate_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:buk/config.dart' as config;

class SettingsButtons extends StatefulWidget {
  const SettingsButtons({Key? key}) : super(key: key);

  @override
  State<SettingsButtons> createState() => _SettingsButtonsState();
}

class _SettingsButtonsState extends State<SettingsButtons> {
  final _formKey = GlobalKey<FormState>();
  String passwordInput = '';

  bool verified = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  String otp = '';
  String verificationID = "";

  @override
  Widget build(BuildContext context) {
    SettingsProvider provider = Provider.of<SettingsProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          Provider.of<UserProvider>(context).user!.displayName!,
          style: GoogleFonts.lato(
              textStyle: TextStyle(color: Colors.grey[800], fontSize: 30)),
        ),
        Text(
          Provider.of<UserProvider>(context).user!.phoneNumber!,
          style: GoogleFonts.lato(
              textStyle: TextStyle(color: Colors.grey[700], fontSize: 15)),
        ),

        // ? Only admins can view awaiting verification users
        isAdmin(context)
            ? TextButton(
                style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const VerificationsScreen(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.help_outline,
                      color: Colors.indigoAccent,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: TranslateText(
                        text: "Awaiting verification",
                        selectable: false,
                        style: GoogleFonts.lato(
                            textStyle: const TextStyle(fontSize: 16),
                            color: Colors.grey[700]),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.grey[700],
                      ),
                    )
                  ],
                ),
              )
            : Container(), //
        // TextButton(
        //   style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
        //   onPressed: () {
        //     provider.toggleNotifications();
        //   },
        //   child: Row(
        //     children: [
        //       const Icon(
        //         Icons.notifications_none,
        //         color: Colors.indigoAccent,
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(left: 10.0),
        //         child: TranslateText(
        //           text: "Notifications",
        //           selectable: false,
        //           style: GoogleFonts.lato(
        //               textStyle: const TextStyle(fontSize: 16),
        //               color: Colors.grey[700]),
        //         ),
        //       ),
        //       const Spacer(),
        //       Switch.adaptive(
        //           value: provider.notifications,
        //           onChanged: (toggled) {
        //             provider.setNotifications(toggled);
        //           })
        //     ],
        //   ),
        // ), // Notifications section
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Row(
            children: [
              const Icon(
                Icons.language,
                color: Colors.indigoAccent,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: TranslateText(
                  text: "Language",
                  selectable: false,
                  style: GoogleFonts.lato(
                      textStyle: const TextStyle(fontSize: 16),
                      color: Colors.grey[700]),
                ),
              ),
              const Spacer(),
              const LanguageSwitch(),
            ],
          ),
        ),
        TextButton(
          style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
          onPressed: () async {
            String url = "mailto:${config.helpEmail}";

            if (await canLaunchUrlString(url)) {
              await launchUrlString(url);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "Failed to launch email service. Please email ${config.helpEmail}")));
            }
          },
          child: Row(
            children: [
              const Icon(
                Icons.help_outline,
                color: Colors.indigoAccent,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: TranslateText(
                  text: "Help",
                  selectable: false,
                  style: GoogleFonts.lato(
                      textStyle: const TextStyle(fontSize: 16),
                      color: Colors.grey[700]),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey[700],
                ),
              )
            ],
          ),
        ), // Help section
        TextButton(
          style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return const DeleteDialog();
                });
          },
          child: Row(
            children: [
              const Icon(
                Icons.delete_outline,
                color: Colors.indigoAccent,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: TranslateText(
                  text: "Delete account",
                  selectable: false,
                  style: GoogleFonts.lato(
                      textStyle: const TextStyle(fontSize: 16),
                      color: Colors.grey[700]),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey[700],
                ),
              )
            ],
          ),
        ), // Delete account
        TextButton(
          style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return Center(
                    child: Container(
                      height: 160,
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                      ),
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TranslateText(
                            textAlign: TextAlign.center,
                            text: "Are you sure you want to logout?",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 24, color: Colors.grey[800]),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: TranslateText(
                                  text: "No",
                                  selectable: false,
                                  style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  FirebaseAuth.instance.signOut();
                                  Provider.of<InitialProvider>(context,
                                          listen: false)
                                      .setPassed(false);
                                  Provider.of<UserProvider>(context,
                                          listen: false)
                                      .clearUser();
                                  Provider.of<Screen>(context, listen: false)
                                      .setScreen(const FeedScreen(), context);
                                },
                                child: TranslateText(
                                  text: "Yes",
                                  selectable: false,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        color: Colors.grey[700], fontSize: 16),
                                  ),
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  );
                });
          },
          child: Row(
            children: [
              const Icon(
                Icons.logout_outlined,
                color: Colors.indigoAccent,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: TranslateText(
                  text: "Logout",
                  selectable: false,
                  style: GoogleFonts.lato(
                      textStyle: const TextStyle(fontSize: 16),
                      color: Colors.grey[700]),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ), // Logout
        TextButton(
          style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: const BlockedUsersScreen(),
              ),
            );
          },
          child: Row(
            children: [
              const Icon(
                Icons.block,
                color: Colors.indigoAccent,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: TranslateText(
                  text: "Blocked users",
                  selectable: false,
                  style: GoogleFonts.lato(
                      textStyle: const TextStyle(fontSize: 16),
                      color: Colors.grey[700]),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey[700],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  bool isAdmin(BuildContext context) {
    return Provider.of<UserProvider>(context, listen: false).admin;
  }
}
