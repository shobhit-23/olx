import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:olx/authenti/phone_auth.dart';
import 'package:olx/form/UserReviewScreen.dart';
import 'package:olx/form/seller_form.dart';
import 'package:olx/screens/home_screen.dart';
import 'package:olx/screens/login_page.dart';
import 'package:olx/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:olx/form/cat_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;

  runApp(
    MultiProvider(
      providers: [
        Provider<CategoryProvider>(
            create: (_) => CategoryProvider()), //    olx/form/cat_provider.dart
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 3)),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(home: splashscreen());
        } else {
          // Loading is done, return the app:
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.orangeAccent,
            ),
            home: login(),
            routes: {
              login.id: (context) => login(),
              home_screen.id: (context) => home_screen(),
              phoneauthscreen.id: (context) => phoneauthscreen(),
              UserReviewScreen.id: (context) => UserReviewScreen(),
            },
          );
        }
      },
    );
  }
}
