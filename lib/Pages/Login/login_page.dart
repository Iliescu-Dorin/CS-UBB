import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'home_page.dart';
import '../Inbox_page.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}
 TextEditingController _textControllerEmail;
  String _name = "";
  TextEditingController _textControllerPass;
  String _pass = "";
class _LoginPageState extends State<LoginPage> {
 

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _name = prefs.getString("name");
    _pass = prefs.getString("pass");
    setState(() {
      _textControllerEmail = new TextEditingController(text: _name);
      _textControllerPass = new TextEditingController(text: _pass);
    });
  }

  Future<bool> saveNamePreference(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("name", name);
    return prefs.commit();
  }

  Future<bool> savePassPreference(String pass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("pass", pass);
    return prefs.commit();
  }

  Future<String> getNamePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString("name");
    return name;
  }

  Future<String> getPassPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String pass = prefs.getString("pass");
    return pass;
  }

  @override
  void initState() {
    _name = "";
    _pass = "";
    getSharedPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Theme.of(context).backgroundColor,
        radius: 48.0,
        child: Image.asset('assets/logo.png'),
      ),
    );
    Future<bool> storeName(String name) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      return prefs.setString("name", name);
    }

    final email = TextField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      onChanged: (String str) {
        setState(() {
          _name = str;
          storeName(str);
        });
      },
      controller: _textControllerEmail,
      decoration: InputDecoration(
        hintText: 'User primit de la FSEGA',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    // final pervEmail= Text(_name);

    Future<bool> storePass(String pass) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      return prefs.setString("pass", pass);
    }

    final password = TextField(
      autofocus: false,
      controller: _textControllerPass,
      onChanged: (String str) {
        setState(() {
          _pass = str;
          storePass(str);
        });
      },
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Parola primita de la FSEGA',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    // final prevPass = Text(_pass);

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          var route = new MaterialPageRoute(
              builder: (context) => new HomePage(
                    user: _textControllerEmail.text,
                    pass: _textControllerPass.text,
                  ));
          Navigator.of(context).push(route);
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Logare', style: TextStyle(color: Colors.white)),
      ),
    );

    return Container(
      padding: EdgeInsets.only(left: 24.0, right: 24.0),
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            FlatButton(
              child: Text(
                'Ai uitat contul ?',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              onPressed: () {
                final snackBar = SnackBar(
                  backgroundColor: Colors.grey[900],
                  content: Text(
                    'Asta e ... se mai intampla. Faci un drum pana la FSEGA :)',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  action: SnackBarAction(
                    label: 'Gata',
                    onPressed: () {},
                  ),
                );
                Scaffold.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        ),
      ),
    );
  }
}
