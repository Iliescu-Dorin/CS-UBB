import 'package:UBB/Pages/Dashboard.dart';
import 'package:UBB/Pages/Orar/getOrar.dart';
import 'package:UBB/main.dart';
import 'package:flutter/material.dart';
import 'ListItemZi.dart';

class OrarRework extends StatelessWidget {
  // String sapt;
  // String sp;
  // String an;
  // String gr;
  // String sGr;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      child: Column(
        children: <Widget>[
          new Flexible(
            fit: FlexFit.tight,
            child: loadingOrar
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).accentColor),
                    ),
                  )
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: program.length == 0 ? 0 : program.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (program[index].zi == ziua(date.weekday) &&
                          // (program[index].frecventa == "" ||
                          //     program[index].frecventa == sapt) &&
                          (program[index].formatia == "${spec + anUniv}" ||
                              program[index].formatia == "$grupa" ||
                              program[index].formatia ==
                                  "${grupa + "/" + subGrupa}")) {
                        return new ListItemZI(
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
                    }),
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
