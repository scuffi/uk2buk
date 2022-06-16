import 'package:buk/pages/auth_gate.dart';
import 'package:buk/providers/donations/donations_provider.dart';
import 'package:buk/providers/feed/feed_loader.dart';
import 'package:buk/providers/feed/feed_provider.dart';
import 'package:buk/providers/initial/initial_provider.dart';
import 'package:buk/providers/language/language_enum.dart';
import 'package:buk/providers/language/language_provider.dart';
import 'package:buk/providers/post/post_form_provider.dart';
import 'package:buk/providers/screen/screen_provider.dart';
import 'package:buk/providers/settings_provider.dart';
import 'package:buk/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        // ? Screen handler provider
        ChangeNotifierProvider(create: (_) => Screen()),
        // ? Initial input provider
        ChangeNotifierProvider(create: (_) => InitialProvider()),
        // ? User storage provider
        ChangeNotifierProvider(create: (_) => UserProvider()),
        // ? Feed page providers
        ChangeNotifierProvider(create: (context) => FeedData()),
        ChangeNotifierProvider(create: (context) => FeedLoader()),
        // ? Language selection provider
        ChangeNotifierProvider(create: (context) => Language()),
        // ? Post page providers
        ChangeNotifierProvider(create: (context) => PostFormProvider()),
        // ? Settings provider
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        // ? Donations provider
        ChangeNotifierProvider(create: (_) => DonationsProvider()),
      ],
      // child: DevicePreview(
      //   enabled: !kReleaseMode,
      //   builder: (context) => const MyApp(), // Wrap your app
      // ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // Check the currently stored language type and set our language to that type so it doesn't default to something after each run
    Future(
      () async {
        final prefs = await SharedPreferences.getInstance();

        String? lang = prefs.getString("language");
        if (lang != null) {
          Provider.of<Language>(context, listen: false).setLang(LanguageType
              .values
              .firstWhere((element) => element.name == lang));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      theme: ThemeData(
        primaryColor: Colors.indigoAccent,
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.indigoAccent,
        scaffoldBackgroundColor: Colors.black45,
      ),
      // home: const FeedPage(),
      home: const AuthGate(),
    );
  }
}
