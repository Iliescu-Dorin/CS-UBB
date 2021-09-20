import 'dart:async';

import 'package:UBB/Pages/About/About_page.dart';
import 'package:UBB/Pages/Intro/SetariIntro.dart';
import 'package:UBB/Pages/Setari/screens/settings.dart';
import 'package:UBB/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Intro extends StatelessWidget {
  const Intro({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PageView(
        children: <Widget>[
          MyAboutPage(),
          SetariIntro(),
        ],
      ),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> {
  Future checkFirstSeen() async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance(); //INTRO SCREEN PREFERENCES
    bool _seen = (prefs.getBool('seen') == null);
    // bool _seen = (prefs.getBool('seen') ?? false);
    if (_seen) {
      SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
          .then((_) => runApp(new MyApp()));
    } else {
      // prefs.setBool('seen', true);
      SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
          .then((_) => runApp(new Intro()));
    }
  }

  @override
  void initState() {
    super.initState();
    checkFirstSeen();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Text('Loading...'),
      ),
    );
  }
}
