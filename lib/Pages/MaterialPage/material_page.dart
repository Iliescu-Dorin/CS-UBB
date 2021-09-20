import 'dart:ui';
import 'package:UBB/Pages/About/About_page.dart';
import 'package:UBB/Pages/MaterialPage/sexy_bottom_sheet.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyMaterialPage extends StatefulWidget {
  @override
  _MyMaterialPageState createState() => _MyMaterialPageState();
}

class _MyMaterialPageState extends State<MyMaterialPage> {
  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      // backgroundColor: invertColorsMaterial(context),
      body: WillPopScope(
        onWillPop: this.handleBackPressed,
        child: Container(
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10.0,
                      top: 50.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(EvaIcons.arrowIosBack),
                          tooltip: 'Go back',
                          // color: invertColorsMild(context),
                          iconSize: 26.0,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          'Material++',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w600,
                            fontSize: 22.0,
                            fontStyle: FontStyle.italic,
                            // color: invertColorsMild(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: <Widget>[
                      Hero(
                        tag: 'tile0',
                        child: Container(
                          height: _height / 1.8,
                          width: _width / 1.2,
                          margin: EdgeInsets.all(20.0),
                          child: Material(
                            // color: invertInvertColorsMild(context),
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(10.0),
                            // shadowColor: shadowColor(context),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10.0),
                              // splashColor: invertColorsStrong(context),
                              child: null,
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    transitionsBuilder: (
                                      BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation,
                                      Widget child,
                                    ) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: Offset(0.0, 1.0),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: SlideTransition(
                                          position: Tween<Offset>(
                                            begin: Offset.zero,
                                            end: Offset(0.0, 1.0),
                                          ).animate(secondaryAnimation),
                                          child: child,
                                        ),
                                      );
                                    },
                                    transitionDuration:
                                        Duration(milliseconds: 500),
                                    pageBuilder: (BuildContext context,
                                            Animation<double> animation,
                                            Animation<double>
                                                secondaryAnimation) =>
                                        Stack(
                                      children: <Widget>[
                                        Hero(
                                          tag: 'tile0',
                                          child: Container(
                                            child: Material(
                                              // color: invertInvertColorsMild(
                                                  // context),
                                              elevation: 5.0,
                                              // shadowColor: shadowColor(context),
                                              child: InkWell(
                                                // splashColor:
                                                    // invertColorsStrong(context),
                                                child: null,
                                                // onTap: doNothing,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 50.0,
                                          left: 10.0,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Material(
                                                color: Colors.transparent,
                                                child: IconButton(
                                                  icon: Icon(EvaIcons.close),
                                                  tooltip: 'Go back',
                                                  // color:
                                                      // invertColorsMild(context),
                                                  iconSize: 26.0,
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                              Text(
                                                'Close',
                                                style: TextStyle(
                                                  fontFamily: 'Rubik',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 22.0,
                                                  fontStyle: FontStyle.italic,
                                                  // color:
                                                      // invertColorsMild(context),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Center(
                                          child: Hero(
                                            tag: 'elt1',
                                            child: Container(
                                              width: 200.0,
                                              height: 200.0,
                                              child: Image.asset(
                                                'assets/images/favourite1.jpg',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 15.0,
                                          right: 15.0,
                                          child: FloatingActionButton(
                                            heroTag: 'elt2',
                                            // foregroundColor:
                                                // invertInvertColorsMild(context),
                                            // backgroundColor:
                                                // MyColors.accentColor,
                                            elevation: 5.0,
                                            child: Icon(EvaIcons.close),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 100.0,
                        left: 40.0,
                        child: Text(
                          'Hello, world!',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20.0,
                            // color: invertColorsMild(context),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 60.0,
                        left: 40.0,
                        child: Hero(
                          tag: 'elt1',
                          child: Text(
                            'Click me.',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 30.0,
                              // color: invertColorsMild(context),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40.0,
                        right: 40.0,
                        child: Container(
                          height: 40.0,
                          width: 40.0,
                          child: FloatingActionButton(
                            heroTag: 'elt2',
                            // foregroundColor: invertInvertColorsMild(context),
                            // backgroundColor: MyColors.accentColor,
                            elevation: 3.0,
                            child: Icon(EvaIcons.infoOutline),
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) {
                                    return MyAboutPage();
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SexyBottomSheet(), //the awesome sliding up bottom sheet
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> handleBackPressed() {
    if (isBottomSheetOpen) {
      toggleBottomSheet();
      return Future.value(false);
    }
    return Future.value(true);
  }
}
