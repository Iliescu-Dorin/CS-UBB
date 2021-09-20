import 'dart:async';

import 'package:UBB/Pages/About/sexy_tile.dart';
import 'package:UBB/Pages/Intro/SetariIntro.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MyAboutPage extends StatefulWidget {
  @override
  _MyAboutPageState createState() => _MyAboutPageState();
}

class _MyAboutPageState extends State<MyAboutPage> {
  List<String> itemContent = [
    'Ce este Student UBB?',
    'Student UBB este o aplicatie destinata studentilor'
        'de la facultatea de Matematica si Informatica.\n\n Proiectul '
        'este open source, pentru a motiva si alte '
        'persoane catre aceasta initiativa\n\nStudent UBB '
        'incearca sa puna la dispozitie toate informatiile necesare '
        'unui student fie el boboc sau la master.\n\n '
        'Datele personale sunt protejate deoarece salvarile sunt  '
        'locale, accesul la internet fiind doar pentru Web Scraping.\n\nMultumim!',
    'Cum folosesc aplicatia?',
    'La prima porinire se va cere o configurare manuala pentru :\n '
        '  -preluarea orarului,\n '
        '  -Yourself (ajustarea Dashboard-ului in functie de profesorii tai), ',
  ]; //the text in the tile
  bool data;
  Future<String> dataIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    data = prefs.getBool('seen');
  }

  goToSettings() {
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => new SetariIntro()));
  }

  Widget build(BuildContext context) {
    @override
    void initState() {
      new Timer(new Duration(milliseconds: 7000), () {
        goToSettings();
      });
      super.initState();
    }

    return Scaffold(
      // backgroundColor: invertInvertColorsStrong(context),
      body: Hero(
        tag: "center",
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    SexyTile(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              itemContent[0],
                              // style: MyTextStyles.highlightStyle,
                              textAlign: TextAlign.center,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              itemContent[1],
                              style: TextStyle(
                                fontFamily: 'RobotoMono',
                                fontWeight: FontWeight.w400,
                                fontSize: 16.0,
                                // color: invertColorsStrong(context),
                              ),
                              textAlign: TextAlign.left,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            ),
                          ],
                        ),
                      ),
                      // splashColor: MyColors.accentColor,
                    ),
                    SexyTile(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              itemContent[2],
                              // style: MyTextStyles.highlightStyle,
                              textAlign: TextAlign.center,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              itemContent[3],
                              style: TextStyle(
                                fontFamily: 'RobotoMono',
                                fontWeight: FontWeight.w400,
                                fontSize: 16.0,
                                // color: invertColorsStrong(context),
                              ),
                              textAlign: TextAlign.left,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            ),
                          ],
                        ),
                      ),
                      // splashColor: MyColors.accentColor,
                    ),
                    SizedBox(
                      height: 36.0,
                    ),
                    data == true
                        ? Material(
                            color: Colors.transparent,
                            child: IconButton(
                              icon: Icon(EvaIcons.close),
                              tooltip: 'Inapoi',
                              // color:
                              // invertColorsMild(context),
                              iconSize: 26.0,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab',
        child: Icon(
          EvaIcons.github,
          size: 36.0,
        ),
        tooltip: 'Vezi repo. GitHub ',
        // foregroundColor: invertInvertColorsStrong(context),
        // backgroundColor: invertColorsStrong(context),
        elevation: 5.0,
        onPressed: () => launch('https://github.com/Iliescu-Dorin/CS-UBB'),
      ),
    );
  }
}
