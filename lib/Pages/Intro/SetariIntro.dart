import 'package:UBB/Pages/Dashboard.dart';
import 'package:UBB/Pages/MaterialPage/sexy_bottom_sheet.dart';
import 'package:UBB/Pages/Orar/getOrar.dart';
import 'package:UBB/main.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:progress_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

// String saptamana;
String subGrupa;
String grupa;
String spec;
String anUniv;
String tip;
bool dataS;
Future<String> dataSit() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('seen', true);
  return "success";
}

class SetariIntro extends StatefulWidget {
  final String title;
  SetariIntro({Key key, this.title}) : super(key: key);

  @override
  _SetariIntroState createState() => _SetariIntroState();
}

final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

Future<String> dataIntroS() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  dataS = prefs.getBool('seen');
  return "success";
}

class _SetariIntroState extends State<SetariIntro> {
  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
            onTap: onTap != null
                ? () => onTap()
                : () {
                    print('Not set yet');
                  },
            child: child));
  }

  TextEditingController _textControllerEmail;
  TextEditingController _textControllerPass;
  String _name = "";
  String _pass = "";

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _name = prefs.getString("name");
    _pass = prefs.getString("pass");
    setState(() {
      _textControllerEmail = new TextEditingController(text: _name);
      _textControllerPass = new TextEditingController(text: _pass);
    });
  }

  Future<bool> saveSharedPreference(bool tip, String specializare, String an,
      String grupa, String subGrupa) async {
    //, String saptamana
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("tip", tip.toString());
    prefs.setString("specializare", specializare);
    prefs.setString("an", an);
    prefs.setString("grupa", grupa);
    prefs.setString("subGrupa", subGrupa);
    // prefs.setString("saptamana", tip.toString());
    return prefs.commit();
  }

  @override
  void initState() {
    _name = "";
    _pass = "";
    dataIntroS();
    getSharedPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TextTheme textTheme =
    //     dataS != true ? Colors.white : Theme.of(context).textTheme;    //!!!de rezolvat
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            "Settings",
            style: TextStyle(),
          ),
        ),
        body: Stack(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5.0),
            child: ListView(
              children: <Widget>[
                // ListTile(
                //   title: Text(
                //     "Dark Mode",
                //     style: TextStyle(
                //       fontWeight: FontWeight.w900,
                //     ),
                //   ),
                //   subtitle: Text("Use the dark mode"),
                //   trailing: Switch(
                //     value:
                //   ),
                // ),
                Divider(),
                FormBuilder(
                  key: _fbKey,
                  initialValue: {
                    'date': DateTime.now(),
                    'accept_terms': false,
                  },
                  autovalidate: false,
                  child: Hero(
                    tag: "center",
                    child: _buildTile(
                      Column(
                        children: <Widget>[
                          Text(
                            "Configurare",
                            textAlign: TextAlign.center,
                            // style: textTheme.title,   //!!!de rezolvat
                          ),
                          Divider(
                            height: 2,
                            color: Colors.blue,
                          ),
                          FormBuilderSwitch(
                            attribute: "licenta/master",
                            initialValue: false,
                            label: Text("Licenta/Master"),
                          ),
                          FormBuilderSegmentedControl(
                            attribute: "an",
                            validators: [FormBuilderValidators.required()],
                            options: List.generate(3, (i) => i + 1)
                                .map((number) =>
                                    FormBuilderFieldOption(value: number))
                                .toList(),
                          ),
                          FormBuilderDropdown(
                            attribute: "specializare",
                            hint: Text('Selecteaza Specializarea'),
                            validators: [FormBuilderValidators.required()],
                            items: [
                              'M',
                              'I',
                              'MI',
                              'MIE',
                              'MM',
                              'IM',
                              'MIM',
                              'IE',
                              'IG',
                              'MD',
                              'MDm',
                              'MAv',
                              'SIA',
                              'BD',
                              'IS',
                              'ICA',
                              'PDAE',
                              'CIP',
                              'ADM'
                            ]
                                .map((specializare) => DropdownMenuItem(
                                    value: specializare,
                                    child: Text("$specializare")))
                                .toList(),
                          ),
                          FormBuilderDropdown(
                            attribute: "grupa",
                            hint: Text('Selecteaza Grupa'),
                            validators: [FormBuilderValidators.required()],
                            items: [
                              911,
                              912,
                              913,
                              914,
                              915,
                              916,
                              917,
                              921,
                              922,
                              923,
                              924,
                              925,
                              926,
                              927,
                              931,
                              932,
                              933,
                              934,
                              935,
                              936,
                              711,
                              712,
                              713,
                              721,
                              722,
                              723,
                              731,
                              732,
                              511,
                              512,
                              513,
                              514,
                              521,
                              522,
                              523,
                              524,
                              531,
                              532,
                              533,
                              211,
                              212,
                              213,
                              214,
                              215,
                              216,
                              217,
                              221,
                              222,
                              223,
                              224,
                              225,
                              226,
                              227,
                              231,
                              232,
                              233,
                              234,
                              235,
                              236,
                              237,
                              411,
                              421,
                              431,
                              111,
                              121,
                              131,
                              811,
                              812,
                              821,
                              611,
                              621,
                              631,
                              311,
                              312,
                              313,
                              314,
                              321,
                              322,
                              323,
                              331,
                              332,
                              333,
                              334,
                              247,
                              257,
                              243,
                              253,
                              242,
                              252,
                              248,
                              248,
                              258,
                              258,
                              246,
                              256,
                              144,
                              154,
                              143,
                              153,
                              142,
                              152,
                              249,
                              259,
                              244,
                              254,
                              241,
                              1111,
                              1112,
                              1211,
                              1212
                            ]
                                .map((grupa) => DropdownMenuItem(
                                    value: grupa, child: Text("$grupa")))
                                .toList(),
                          ),
                          FormBuilderSegmentedControl(
                            attribute: "subGrupa",
                            validators: [FormBuilderValidators.required()],
                            options: List.generate(2, (i) => i + 1)
                                .map((number) =>
                                    FormBuilderFieldOption(value: number))
                                .toList(),
                          ),
                          // FormBuilderSwitch(
                          //   attribute: "saptamana",
                          //   initialValue: false,
                          //   label: Text("Saptamana Impara|Para"),
                          // ),
                          SizedBox(
                            height: 15.0,
                          ),
                          // ],
                          // ),
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: <Widget>[
                          // MaterialButton(
                          //   child: Text("Reset"),
                          //   onPressed: () {
                          //     _fbKey.currentState.reset();
                          //   },
                          // ),
                          ProgressButton(
                            child: Text("Gata"),
                            onPressed: () async {
                              if (_fbKey.currentState.saveAndValidate()) {
                                await makeConfigs();
                                SharedPreferences sp =
                                    await SharedPreferences.getInstance();
                                String _an = sp.getString("an");
                                String _subGrupa = sp.getString("subGrupa");
                                String _specializare =
                                    sp.getString("specializare");
                                String _tip = sp.getString("tip");
                                // String _saptamana = sp.getString("saptamana");
                                String _grupa = sp.getString("grupa");
                                setState(() {
                                  anUniv = _an;
                                  subGrupa = _subGrupa;
                                  spec = _specializare;
                                  _tip == "false" ? tip = "" : tip = "Ma";
                                  // saptamana = _saptamana;
                                  grupa = _grupa;
                                });
                                // void updateSpecializare(String value) async {
                                //   setState(() {
                                //     spec = value;
                                //   });
                                // }

                                // void updateAn(String value) async {
                                //   setState(() {
                                //     anUniv = value;
                                //   });
                                // }

                                // void updateTip(String value) async {
                                //   setState(() {
                                //     switch (value) {
                                //       case "true":
                                //         tip = "Ma";
                                //         break;
                                //       case "false":
                                //         tip = "";
                                //         break;
                                //       default:
                                //     }
                                //   });
                                // }

                                // void updateGrupa(String value) async {
                                //   setState(() {
                                //     grupa = value;
                                //   });
                                // }

                                // void updateSubGrupa(String value) async {
                                //   setState(() {
                                //     subGrupa = value;
                                //   });
                                // }

                                // void updateSaptamana(String value) async {
                                //   setState(() {
                                //     switch (value) {
                                //       case "true":
                                //         saptamana = "2";
                                //         break;
                                //       case "false":
                                //         saptamana = "1";
                                //         break;
                                //       default:
                                //     }
                                //   });
                                // }

                                // Future<String> getTip() async {
                                //   SharedPreferences sp =
                                //       await SharedPreferences.getInstance();
                                //   String tip = sp.getString("tip");
                                //   return tip;
                                // }

                                // Future<String> getSpecializare() async {
                                //   SharedPreferences sp =
                                //       await SharedPreferences.getInstance();
                                //   String specializare =
                                //       sp.getString("specializare");
                                //   return specializare;
                                // }

                                // Future<String> getAn() async {
                                //   SharedPreferences sp =
                                //       await SharedPreferences.getInstance();
                                //   String an = sp.getString("an");
                                //   return an;
                                // }

                                // Future<String> getGrupa() async {
                                //   SharedPreferences sp =
                                //       await SharedPreferences.getInstance();
                                //   String grupa = sp.getString("grupa");
                                //   return grupa;
                                // }

                                // Future<String> getSubGrupa() async {
                                //   SharedPreferences sp =
                                //       await SharedPreferences.getInstance();
                                //   String subGrupa = sp.getString("subGrupa");
                                //   return subGrupa;
                                // }

                                // Future<String> getSaptamana() async {
                                //   SharedPreferences sp =
                                //       await SharedPreferences.getInstance();
                                //   String saptamana = sp.getString("saptamana");
                                //   return saptamana;
                                // }

                                // await getSpecializare().then(updateSpecializare);
                                // await getAn().then(updateAn);
                                // await getTip().then(updateTip);
                                // await getSubGrupa().then(updateSubGrupa);
                                // await getGrupa().then(updateGrupa);
                                // await getSaptamana().then(updateSaptamana);
                                String data;
                                var now = new DateTime.now();
                                if (now.month >= 10 && now.month <= 12)
                                  data = "${now.year}-1";
                                else if (now.month >= 1 && now.month <= 2)
                                  data = "${now.year - 1}-1";
                                else
                                  data = "${now.year - 1}-2";

                                String url =
                                    "http://www.cs.ubbcluj.ro/files/orar/$data/tabelar/$tip$spec$anUniv.html";

                                var client = Client();
                                Response response = await client.get(url);
                                int code = response.statusCode;
                                RegExp exp3 = new RegExp(
                                    r"(?<=\. |C.d.asociat )(.*?)(?<=$)");
                                if (code == 200) {
                                  setState(
                                    () {
                                      dataSit();
                                      program.clear();
                                      loadingOrar = false;
                                      // Use html parser
                                      var document = parse(response.body);
                                      var table = document
                                          .getElementsByTagName('table');
                                      var rows = table[int.parse(subGrupa) - 1]
                                          .getElementsByTagName('tr');
                                      // table[int.parse(
                                      //             grupa.toString().substring(grupa.toString().length - 1)) -
                                      //         1]
                                      //     .getElementsByTagName('tr');
                                      var cols;
                                      rows.forEach(
                                        (r) {
                                          if (r != rows[0]) {
                                            cols = r.getElementsByTagName('td');
                                            Materie intervalOrar =
                                                new Materie();
                                            intervalOrar.zi = cols[0].innerHtml;
                                            intervalOrar.ora =
                                                cols[1].innerHtml;
                                            intervalOrar.frecventa =
                                                cols[2].innerHtml.substring(6);
                                            intervalOrar.sala = cols[3]
                                                .innerHtml
                                                .replaceAll(
                                                    new RegExp(r'<[^>]*>'), '');
                                            intervalOrar.formatia =
                                                cols[4].innerHtml;
                                            intervalOrar.tipul =
                                                cols[5].innerHtml;
                                            intervalOrar.disciplina = cols[6]
                                                .innerHtml
                                                .replaceAll(
                                                    new RegExp(r'<[^>]*>'), '');
                                            final matches2 = exp3.firstMatch(
                                                cols[7].innerHtml.replaceAll(
                                                    new RegExp(r'<[^>]*>'),
                                                    ''));
                                            intervalOrar.cadrulDidactic =
                                                matches2.group(1);
                                            program.add(intervalOrar);

                                            // Navigator.pop(context);
                                            runApp(new MyApp());
                                          }
                                        },
                                      );
                                    },
                                  );
                                  return "Success";
                                } else {
                                  setState(() {
                                    loadingOrar = false;
                                  });
                                  return "Something went wrong";
                                }
                              }
                            },
                            buttonState: ButtonState.normal,
                            backgroundColor: Colors.blue,
                            progressColor: Colors.indigo[800],
                          ),
                          // MaterialButton(
                          //   child: Text("Gata"),
                          //   onPressed:
                          // ),
                        ],
                        // ),
                        // ],
                      ),
                    ),
                  ),

                  // SexyBottomSheet(),
                )
              ],
            ),
          )
        ]));
  }

  makeConfigs() async {
    saveSharedPreference(
      _fbKey.currentState.value["licenta/master"],
      _fbKey.currentState.value["specializare"].toString(),
      _fbKey.currentState.value["an"].toString(),
      _fbKey.currentState.value["grupa"].toString(),
      _fbKey.currentState.value["subGrupa"].toString(),
      // _fbKey.currentState.value["saptamana"].toString(),
    ).then((bool commited) => (print("success")));

    print(_fbKey.currentState.value);
  }

  bool isThemeCurrentlyDark(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return true;
    } else {
      return false;
    }
  } //returns current theme status
}

///inceput de semestru I:       1.10.AN   (AN/1)
///an nou:                      01.01.AN  (AN/1)
///sfarsit de semestru I:	      23.02.AN  (AN-1/1)
///inceput de semestru II:      24.02 AN  (AN-1/2)
///sfarsit de semsestru II:     12.07.AN  (AN-1/2)
