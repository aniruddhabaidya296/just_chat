import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:just_chat/pages/email_login.dart';
import 'package:just_chat/pages/email_sign_up.dart';
import 'package:just_chat/pages/homepage.dart';
import 'package:just_chat/pages/login.dart';
// import 'package:splashscreen/splashscreen.dart';

import 'components/size_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: IntroSplashScreen(),
      routes: {
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/email_sign_up': (context) => EmailSignUp(),
        '/email_log_in': (context) => EmailLogIn()
      },
    );
  }
}

class IntroSplashScreen extends StatefulWidget {
  @override
  _IntroSplashScreenState createState() => _IntroSplashScreenState();
}

class _IntroSplashScreenState extends State<IntroSplashScreen> {
  @override
  void initState() {
    User result = FirebaseAuth.instance.currentUser;
    super.initState();
    Timer(
        Duration(seconds: 4),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => result != null
                ? HomePage(currentUserId: result.uid)
                : LoginPage())));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/just_chat_logo.png',
          height: SizeConfig.blockWidth * 30,
          width: SizeConfig.blockWidth * 30,
        ),
      ),
    );
  }
}
