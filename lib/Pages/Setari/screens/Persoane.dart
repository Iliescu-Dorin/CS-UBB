import 'dart:convert';
import 'dart:ui';
import 'package:UBB/Pages/MaterialPage/sexy_bottom_sheet.dart';
import 'package:UBB/Pages/Setari/screens/search.dart';
import 'package:UBB/Pages/Setari/screens/settings.dart';
import 'package:UBB/Pages/Setari/widget/superhero.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import '../../../main.dart';

class Persoane extends StatefulWidget {
  final String title;

  const Persoane({Key key, this.title}) : super(key: key);
  @override
  _PersoaneState createState() => _PersoaneState();
}

class _PersoaneState extends State<Persoane> {
  Future<bool> handleBackPressed() {
    if (isBottomSheetOpen) {
      toggleBottomSheet();
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Persoane",
          style: TextStyle(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              profesoriList == null
                  ? print("Chill")
                  : showSearch(
                      context: context,
                      delegate: HeroSearch(all: profesoriList),
                    );
            },
            tooltip: "Cauta",
          ),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: WillPopScope(
        onWillPop: this.handleBackPressed,
        child: Container(
          child: loadingPerosane
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).accentColor),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: profesoriList == null ? 0 : profesoriList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: SuperHero(
                          name: profesoriList[index].name,
                          tip: profesoriList[index].tip,
                          web: profesoriList[index].web,
                          adress: profesoriList[index].adress,
                          domainsOfInterest:
                              profesoriList[index].domainsOfInterest,
                          email: profesoriList[index].email,
                          photo: profesoriList[index].photo,
                        ),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
