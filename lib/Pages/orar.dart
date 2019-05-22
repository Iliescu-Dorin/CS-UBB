import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_html_widget/flutter_html_widget.dart';
import 'package:flutter_html/flutter_html.dart';

class Orar extends StatefulWidget {
  Orar({Key key}) : super(key: key);

  _OrarState createState() => _OrarState();
}

class _OrarState extends State<Orar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        color: Colors.white,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
//               child: SizedBox(
//                 width: 200.0,
                // height: 100.0,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Color(0xea1a237e),
                  child:
                  //   Html(
                  // data: "",
//                   //Optional parameters:
//                   padding: EdgeInsets.all(8.0),
//                   backgroundColor: Colors.white70,
//                   defaultTextStyle: TextStyle(fontFamily: 'serif',fontSize: 5.0),
                  // linkStyle: const TextStyle(
//                     color: Colors.redAccent,
//                     decorationColor: Colors.redAccent,
//                     decoration: TextDecoration.underline,
//                   ),
//                   onLinkTap: (url) {
//                     // open url in a webview
//                   },
//                 ),

                      Text(
                    '..Orar..',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            // )
          ],
        ),
      ),
    );
  }
}
