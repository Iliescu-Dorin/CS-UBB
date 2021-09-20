import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:link_text/link_text.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'MovieResModel.dart';

class MovieDetail extends StatelessWidget {
  final PostResponse data;

  MovieDetail({this.data});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => launch(data.link),
          child: Icon(EvaIcons.browserOutline),
        ),
        body: Scaffold(
          backgroundColor: Theme.of(context).unselectedWidgetColor,
          body: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                      tag: data.title,
                      child: Container(
                        height: 200.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                            image: NetworkImage(
                              data.contentImage == ""
                                  ? data.image
                                  : data.contentImage,
                            ),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      data.title,
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    LinkText(
                      text: data.content,
                      textAlign: TextAlign.center,
                      linkStyle: TextStyle(color: Colors.purpleAccent),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Divider(),
                    Center(
                      child: LinkText(
                        text: data.date,
                        textAlign: TextAlign.justify,
                        linkStyle: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
