import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pollselect/auth/login.dart';
import 'package:pollselect/auth/signup.dart';
import 'package:pollselect/home_page.dart';
import 'package:pollselect/intro_screen/intro_a.dart';
import 'package:pollselect/user_shared_prefrences.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PollingApp(),
  ));
}

class PollingApp extends StatefulWidget {
  const PollingApp({super.key});

  @override
  State createState() => SplashScreen();
}

class SplashScreen extends State<PollingApp> {
  @override
  void initState() {
    super.initState();
    // Initialize user shared preferences
    Usersharedpreferences.init();

    // Wait for 4 seconds and navigate based on login status
    Future.delayed(
      const Duration(seconds: 3),
          () {
        bool? loginstatus = Usersharedpreferences.getLogin() ?? false;
        if (loginstatus == true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          bool? status = Usersharedpreferences.getFirstTime() ?? false;
          if (status == false) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const IntroScreen1()));
          } else {
            bool? signedStatus = Usersharedpreferences.getSignedup() ?? false;
            if (signedStatus == true) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignupPage()),
              );
            }
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey, // Set background color here
      body: Container(
        color: Colors.white, // Set background color for container
        child: Center(
          child: Lottie.asset('assets/splash.json',
              repeat: true), // Lottie animation
        ),
      ),
    );
  }
}
