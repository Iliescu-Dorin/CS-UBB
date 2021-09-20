import 'dart:convert';
import 'package:UBB/Pages/Stiri/MovieItem.dart';
import 'package:UBB/Pages/Stiri/MovieResModel.dart';
import 'package:UBB/main.dart';
import 'package:html/parser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({this.title});

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String apiUrl = "https://cs.ubbcluj.ro/wp-json/wp/v2/";
  String parseHtmlString(String htmlString) {
    var document = parse(htmlString);

    String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Theme.of(context).backgroundColor,
      child: loadingPerosane
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).accentColor),
              ),
            )
          : ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return MovieItem(
                  data: date[index],
                );
              },
              itemCount: posts == null ? 0 : posts.length,
            ),
    );
    // Stack(fit: StackFit.expand, children: [
    //   Center(
    //     child: SizedBox(
    //       width: 200.0,
    //       height: 100.0,
    //       child: Shimmer.fromColors(
    //         baseColor: Theme.of(context).primaryColor,
    //         highlightColor: Color(0xea1a237e),
    //         child: Text(
    //           '..UBB..',
    //           textAlign: TextAlign.center,
    //           style: TextStyle(
    //             fontSize: 50.0,
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    //   Center(
    //     child: LiquidPullToRefresh(
    //       onRefresh: () {
    //         return null;
    //       },
    //       child: date.length == null
    //           ? Center(
    //               child: CircularProgressIndicator(),
    //             )
    //           : ListView.builder(
    //               itemBuilder: (BuildContext context, int index) {
    //                 return MovieItem(
    //                   data: date[index],
    //                 );
    //               },
    //               itemCount: posts == null ? 0 : posts.length,
    //             ),
    //     ),
    //   )
    // ]
    // )
    // );
  }
}
