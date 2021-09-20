import 'dart:ui';

import 'package:UBB/Pages/Orar/OrarAziMaine/orar_azi.dart';
import 'package:UBB/Pages/Orar/OrarAziMaine/orar_maine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/assets.dart';
import '../utils/custom_clipper.dart';
import '../utils/custom_shadow_path.dart';

class TransactionsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TransactionsViewState();
  }
}

class _TransactionsViewState extends State<TransactionsView> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => buildTabList(context, constraints));
  }

  Widget buildTabList(BuildContext context, BoxConstraints constraints) {
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            children: buildTabs(context, constraints),
          ),
          Container(
            margin: EdgeInsets.only(),
            width: constraints.maxWidth,
            height: constraints.maxHeight - 56,
            // color: Colors.white,
            child: _selectedTabIndex == 0
                ? buildToday(context, constraints)
                : buildTomorrow(context, constraints),
          ),
        ],
      ),
    );
  }

  List<Widget> buildTabs(BuildContext context, BoxConstraints constraints) {
    Widget tab1 = buildTab(context, constraints, "Azi", 0);
    Widget tab2 = buildTab(context, constraints, "Maine", 1);

    return //selectedTabIndex == 0 ? [tab1, tab2] :
        [tab2, tab1];
  }

  Widget buildTab(
      BuildContext context, BoxConstraints constraints, String text, int i) {
    Widget widget = Container(
      height: 56,
      color: _selectedTabIndex == i
          ? Theme.of(context).backgroundColor
          : Colors.transparent,
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = i;
          });
        },
        child: Container(
          alignment: Alignment.center,
          width: constraints.maxWidth / 2,
          margin: EdgeInsets.only(left: i * constraints.maxWidth / 2),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );

    if (_selectedTabIndex == i)
      return IgnorePointer(
        child: ClipShadowPath(
          clipper: TabShapeClipper(index: i),
          shadow: Shadow(color: Colors.black12, blurRadius: 6),
          child: widget,
        ),
      );
    else
      return Opacity(
        child: widget,
        opacity: 0.5,
      );
  }

  buildToday(BuildContext context, BoxConstraints constraints) {
    return Column(
      children: <Widget>[
        OrarRework(),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          //  => Center Row contents horizontally,
          crossAxisAlignment: CrossAxisAlignment.center,
          //  => Center Row contents vertically,
          children: <Widget>[
            Text("Legenda: "),
            Container(
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
            ),
            Text('-Curs '),
            Container(
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
            ),
            Text('-Seminar '),
            Container(
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
            ),
            Text('-Laborator '),
          ],
        ),
      ],
    );
  }

  buildTomorrow(BuildContext context, BoxConstraints constraints) {
    return Column(
      children: <Widget>[
        OrarReworkMaine(),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          //  => Center Row contents horizontally,
          crossAxisAlignment: CrossAxisAlignment.center,
          //  => Center Row contents vertically,
          children: <Widget>[
            Text("Legenda: "),
            Container(
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
            ),
            Text('-Curs '),
            Container(
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
            ),
            Text('-Seminar '),
            Container(
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
            ),
            Text('-Laborator '),
          ],
        ),
      ],
    );
  }
}

class ListItem extends StatelessWidget {
  ListItem({this.image, this.text, this.subtitle, Key key}) : super(key: key);
  final String text;
  final String subtitle;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: <Widget>[
          Image(
            image: Assets.image(image),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(left: 10),
              padding: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                  color: Color.fromRGBO(169, 184, 199, 0.2),
                  width: 1,
                )),
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    text,
                    style: TextStyle(fontSize: 18),
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
      ),
    );
  }
}
