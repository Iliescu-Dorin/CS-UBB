import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';
import 'dart:async';
import 'dart:convert';
import 'package:UBB/main.dart';

class News extends StatefulWidget {
  News({Key key}) : super(key: key);

  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(fit: StackFit.expand, children: [
        Center(
          child: SizedBox(
            width: 200.0,
            height: 100.0,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Color(0xea1a237e),
              child: Text(
                '..UBB..',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Center(
          child: LiquidPullToRefresh(
            onRefresh: () => this.getPosts(),
            child: ListView.builder(
              itemCount: posts == null ? 0 : posts.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: <Widget>[
                    Card(
                      child: Column(
                        children: <Widget>[
                          new FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: posts[index]["featured_media"] == 0
                                ? 'http://starubb.institute.ubbcluj.ro/wp-content/uploads/2017/01/Logo-UBB-Traditie-si-Excelenta.png'
                                : posts[index]["_embedded"]["wp:featuredmedia"]
                                    [0]["source_url"],
                          ),
                          new FlatButton(
                            onPressed: () => _launchURL1(posts[index]["link"]),
                            child: new Text(posts[index]["title"]['rendered'],
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center),
                          ),
                          new Padding(
                            padding: EdgeInsets.all(10.0),
                            child: new ListTile(
                              subtitle: new Text(posts[index]["excerpt"]
                                      ["rendered"]
                                  .replaceAll(new RegExp(r'<[^>]*>'), '')),
                            ),
                          ),
                          new Text(
                            "${posts[index]["date"].toString().substring(8, 10)}/${posts[index]["date"].toString().substring(5, 7)}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ]),
    );
  }

  _launchURL1(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      final snackBar =
          SnackBar(content: Text('Nu s-a putut afisa pagina $url'));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }
}
