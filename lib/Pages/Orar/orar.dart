import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import 'OrarAziMaine/ListItem.dart';
import 'getOrar.dart';

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
    return Container(
      color: Colors.transparent,
      child: Column(
        children: <Widget>[
          new Container(
            padding: EdgeInsets.all(12.0),
            width: MediaQuery.of(context).size.width,
            // height: 60.0,
            child: new Row(
              children: <Widget>[
                Text("  ", style: TextStyle(fontSize: 12)),
                Expanded(
                    flex: 3,
                    child: Center(
                        child: Text("Orele", style: TextStyle(fontSize: 12)))),
                Expanded(
                    flex: 3,
                    child: Center(
                        child: Text("Sala", style: TextStyle(fontSize: 12)))),
                Expanded(
                    flex: 1,
                    child: Center(
                        child: Text("   ", style: TextStyle(fontSize: 12)))),
                Expanded(
                    flex: 6,
                    child: Center(
                        child: Text("Disciplina",
                            style: TextStyle(fontSize: 12)))),
                Expanded(
                    flex: 5,
                    child: Center(
                        child: Text("Cadrul Didactic",
                            style: TextStyle(fontSize: 12)))),
              ],
            ),
          ),
          new Flexible(
            fit: FlexFit.tight,
            child: ListView.builder(
              itemCount: program.length == 0 ? 0 : program.length,
              itemBuilder: (BuildContext context, int index) {
                if (program[index].formatia == "${spec + anUniv}" ||
                    program[index].formatia == "$grupa" ||
                    program[index].formatia == "${grupa + "/" + subGrupa}") {
                  return new ListItem(
                    zi: program[index].zi,
                    ora: program[index].ora,
                    frecventa: program[index].frecventa,
                    sala: program[index].sala,
                    formatia: program[index].formatia,
                    tipul: program[index].tipul,
                    disciplina: program[index].disciplina,
                    cadrulDidactic: program[index].cadrulDidactic,
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

DateTime date = DateTime.now();
ziua(int date) {
  switch (date) {
    case 1:
      return "Luni";
    case 2:
      return "Marti";
    case 3:
      return "Miercuri";
    case 4:
      return "Joi";
    case 5:
      return "Vineri";
  }
}
