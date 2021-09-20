import 'package:flutter/material.dart';
import '../Inbox_page.dart';

class HomePage extends StatelessWidget {
  static String tag = 'home-page';

  final String user;
  final String pass;
  HomePage({Key key, this.user, this.pass}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alucard = Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircleAvatar(
          radius: 72.0,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('assets/alucard.jpg'),
        ),
      ),
    );

    final welcome = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Bun Venit',
        style: TextStyle(fontSize: 28.0, color: Colors.white),
      ),
    );

    final lorem = new Imbox(
      user: user,
      pass: pass,
    );

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: Theme.of(context).brightness == Brightness.light
                ? [
                    Colors.blue,
                    Colors.lightBlueAccent,
                  ]
                : [
                    Colors.black,
                    Colors.black12,
                  ]),
      ),
      child: Column(
        children: <Widget>[alucard, welcome, lorem],
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      floatingActionButton: new FloatingActionButton(
        child: Icon(Icons.art_track),
        onPressed: null,
      ),
      body: body,
    );
  }
}
