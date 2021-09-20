import 'package:flutter/material.dart';

class ListItemZI extends StatelessWidget {
  final String zi;
  final String ora;
  final String frecventa;
  final String sala;
  final String formatia;
  final String tipul;
  final String disciplina;
  final String cadrulDidactic;

  const ListItemZI(
      {Key key,
      this.zi,
      this.ora,
      this.frecventa,
      this.sala,
      this.formatia,
      this.tipul,
      this.disciplina,
      this.cadrulDidactic})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              // Text(
              //   zi.substring(0, 2),
              //   style: TextStyle(fontSize: 12),
              // ),
              Expanded(
                  flex: 3,
                  child: Center(
                      child: Text(ora,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          )))),
              Expanded(
                  flex: 3,
                  child: Center(
                      child: Text(sala,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Colors.blue,
                          )))),
              Expanded(
                flex: 1,
                child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      _createDot(),
                      Text(
                        frecventa,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: Colors.black),
                      )
                    ]),
              ),
              Expanded(
                  flex: 6,
                  child: Center(
                    child: Text(
                      disciplina,
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  )),
              Expanded(
                  flex: 5,
                  child: Center(
                      child: Text(cadrulDidactic,
                          style: TextStyle(fontSize: 12)))),
            ],
          ),
          // SizedBox(
          //   height: 5,
          // ),
          Divider(),
        ],
      ),
    );
  }

  _createDot() {
    switch (tipul) {
      case "Laborator":
        return Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
        );
      case "Seminar":
        return Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
        );
      case "Curs":
        return Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
        );
    }
  }
}
