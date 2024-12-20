import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notifications/channels_screen.dart';
import 'package:notifications/firebase_api.dart';
import 'package:notifications/firebase_options.dart';
import 'package:notifications/my_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAPI.initNotifications();
  await FirebaseAPI.getDeviceToken();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      routes: {
        ChannelsScreen.channelsRoute: (context) => ChannelsScreen(),
      },
    );
  }
}
