import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:secoya_market/Screens/onBoard%20Screen/on_board.dart';
import 'package:secoya_market/Screens/onBoard%20Screen/on_board1.dart';
import 'package:secoya_market/registration/login.dart';
import 'package:secoya_market/registration/register.dart';
import 'package:shimmer/shimmer.dart';

import 'Screens/home_screen/home_screen.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Secoya',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Shimmer.fromColors(
              child: Center(
                child: CircularProgressIndicator(),
              ),
              baseColor: Colors.green,
              highlightColor: Colors.yellow,
            );
          } else if (snapshot.hasError) {
            return AlertDialog(
              title: Text('There is an issue'),
              content: Text('Please check your internet or restart the app.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          } else if (snapshot.hasData) {
            return HomeScreen();
          } else {
            return OnBoardScreen1();
          }
        },
      ),
    );
  }
}
