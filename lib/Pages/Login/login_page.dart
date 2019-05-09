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

class _LoginPageState extends State<LoginPage> {
  String _name="";
  String _pass="";
  var _textControllerEmail = new TextEditingController(text: '');
  var _textControllerPass = new TextEditingController(text: '');

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
    getNamePreference().then(updateName);
        getPassPreference().then(updatePass);
                super.initState();
              }
              @override
              Widget build(BuildContext context) {
                final logo = Hero(
                  tag: 'hero',
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 48.0,
                    child: Image.asset('assets/logo.png'),
                  ),
                );
            
                final email = TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  controller: _textControllerEmail, 
                  decoration: InputDecoration(
                    hintText: 'User primit de la FSEGA',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  ),
                );
                // final pervEmail= Text(_name);
            
                final password = TextFormField(
                  autofocus: false,
                  controller: _textControllerPass,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Parola primita de la FSEGA',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  ),
                );
            
                // final prevPass = Text(_pass);

                void saveName() {
                  String name = _textControllerEmail.text;
                  saveNamePreference(name);
                  String pass = _textControllerPass.text;
                  saveNamePreference(pass).then((bool committed) {
                    var route = new MaterialPageRoute(
                        builder: (context) => new HomePage(
                              user: _textControllerEmail.text,
                              pass: _textControllerPass.text,
                            ));
                    Navigator.of(context).push(route);
                  });
                }
            
                final loginButton = Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    onPressed: () {saveName();
                      // var route = new MaterialPageRoute(
                      //     builder: (context) => new HomePage(
                      //           user: _textControllerEmail.text,
                      //           pass: _textControllerPass.text,
                      //         ));
                      // Navigator.of(context).push(route);
                    },
                    padding: EdgeInsets.all(12),
                    color: Colors.lightBlueAccent,
                    child: Text('Logare', style: TextStyle(color: Colors.white)),
                  ),
                );
            
                final forgotLabel = FlatButton(
                  child: Text(
                    'Ai uitat contul ?',
                    style: TextStyle(color: Colors.black54),
                  ),
                  onPressed: () {
                    final snackBar = SnackBar(
                      content:
                          Text('Asta e ... se mai intampla. Faci un drum pana la FSEGA :)'),
                      action: SnackBarAction(
                        label: 'Gata', onPressed: () {},
                      ),
                    );
                    Scaffold.of(context).showSnackBar(snackBar);
                  },
                );
            
                return Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 24.0, right: 24.0),
                      children: <Widget>[
                        logo,
                        SizedBox(height: 48.0),
                        email,
                        SizedBox(height: 8.0),
                        password,
                        SizedBox(height: 24.0),
                        loginButton,
                        forgotLabel
                      ],
                    ),
                  ),
                );
              }
            
              void updateName(String name) {
                setState(() {
                  this._name=name;
                });
          }
        
                void updatePass(String pass) {
                  setState(() {
                    this._pass=pass;
                  });
                }
}
