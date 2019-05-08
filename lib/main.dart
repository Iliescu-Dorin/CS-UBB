import 'dart:async';

import 'package:UBB/menu_page.dart';
import 'package:flutter/material.dart';
import 'package:UBB/zoom_scaffold.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student UBB',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}
List posts;
class _MyHomePageState extends State<MyHomePage> {
  final String apiUrl = "https://cs.ubbcluj.ro/wp-json/wp/v2/";
  

  Future<String> getPosts() async {
    var res = await http.get(
        Uri.encodeFull(apiUrl + "posts?_embed&categories=24+72+26"),
        headers: {"Accept": "application/json"});
        
    setState(() {
      var resBody = json.decode(res.body);
      posts = resBody;
    });

    return "Success!";
  }
  @override
  void initState() {
    super.initState();
     this.getPosts();
  }
  @override
  Widget build(BuildContext context) {
    return new ZoomScaffold(
      menuScreen: MenuScreen(),
      contentScreen: Layout(
          contentBuilder: (cc) => Container(
                color: Colors.grey[200],
                child: Container(
                  color: Colors.grey[200],
                ),
              )),
    );
  }
}
