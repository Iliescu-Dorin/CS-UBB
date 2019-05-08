import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_html_widget/flutter_html_widget.dart';
import 'package:flutter_html/flutter_html.dart';

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
    return Scaffold(
      body: new Container(
        color: Colors.white,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: SizedBox(
                width: 200.0,
                height: 100.0,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Color(0xea1a237e),
                  child:
//                     Html(
//                   data: """

// <html><head>
// <title>Anul 1 Informatica - in limba germana</title>
// <link href='../style.css' rel='stylesheet' type='text/css'>
// <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=ISO-8859-2">
// </head><body><center>
// <h1>Grupa 711</h1>
// <table border=1 cellspacing=0 cellpadding=0>
// <tr align=center>
// <th>Ziua</th>
// <th>Orele</th>
// <th>Frecventa</th>
// <th>Sala</th>
// <th>Formatia</th>
// <th>Tipul</th>
// <th>Disciplina</th>
// <th>Cadrul didactic</th>
// </tr>
// <tr align=center>
// <td>Luni</td>
// <td class="bloc">8-10</td>
// <td>&nbsp;</td>
// <td><a href="../sali/L307.html" >L307</a></td>
// <td>711/2</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG5006.html" >Programare orientata obiect</a></td>
// <td><a href="../cadre/crio.html" >Drd. Crisan Ioan</a></td>
// </tr>
// <tr align=center>
// <td>Luni</td>
// <td class="bloc">10-12</td>
// <td>sapt. 1</td>
// <td><a href="../sali/C510.html" >C510</a></td>
// <td>711</td>
// <td>Seminar</td>
// <td><a href="../disc/MLG5007.html" >Sisteme de operare</a></td>
// <td><a href="../cadre/mida.html" >Lect. MIRCEA Ioan Gabriel</a></td>
// </tr>
// <tr align=center>
// <td>Luni</td>
// <td class="bloc">12-14</td>
// <td>&nbsp;</td>
// <td><a href="../sali/L336.html" >L336</a></td>
// <td>711/1</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG5007.html" >Sisteme de operare</a></td>
// <td><a href="../cadre/luco.html" >C.d.asociat LUCA Corneliu</a></td>
// </tr>
// <tr align=center>
// <td>Luni</td>
// <td class="bloc">14-16</td>
// <td>&nbsp;</td>
// <td><a href="../sali/L336.html" >L336</a></td>
// <td>711/2</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG5007.html" >Sisteme de operare</a></td>
// <td><a href="../cadre/luco.html" >C.d.asociat LUCA Corneliu</a></td>
// </tr>
// <tr align=center>
// <td>Luni</td>
// <td class="bloc">16-18</td>
// <td>&nbsp;</td>
// <td><a href="../sali/L307.html" >L307</a></td>
// <td>IG1</td>
// <td>Laborator</td>
// <td><a href="../disc/MLR2002.html" >Metode avansate de rezolvare a problemelor de matematica si informatica</a></td>
// <td><a href="../cadre/mida.html" >Lect. MIRCEA Ioan Gabriel</a></td>
// </tr>
// <tr align=center>
// <td>Luni</td>
// <td class="bloc">18-20</td>
// <td>&nbsp;</td>
// <td><a href="../sali/C310.html" >C310</a></td>
// <td>IG1</td>
// <td>Curs</td>
// <td><a href="../disc/MLR2002.html" >Metode avansate de rezolvare a problemelor de matematica si informatica</a></td>
// <td><a href="../cadre/mida.html" >Lect. MIRCEA Ioan Gabriel</a></td>
// </tr>
// <tr align=center>
// <td>Marti</td>
// <td class="bloc">8-10</td>
// <td>&nbsp;</td>
// <td><a href="../sali/NTTSocrate.html" >NTTSocrate</a></td>
// <td>IG1</td>
// <td>Curs</td>
// <td><a href="../disc/MLG5007.html" >Sisteme de operare</a></td>
// <td><a href="../cadre/drsa.html" >Conf. AVRAM Sanda</a></td>
// </tr>
// <tr align=center>
// <td>Marti</td>
// <td class="bloc">10-12</td>
// <td>sapt. 1</td>
// <td><a href="../sali/A313.html" >A313</a></td>
// <td>711</td>
// <td>Seminar</td>
// <td><a href="../disc/MLG0010.html" >Sisteme dinamice</a></td>
// <td><a href="../cadre/viad.html" >Lect. VIOREL Adrian</a></td>
// </tr>
// <tr align=center>
// <td>Marti</td>
// <td class="bloc">14-16</td>
// <td>&nbsp;</td>
// <td><a href="../sali/A323.html" >A323</a></td>
// <td>711</td>
// <td>Seminar</td>
// <td><a href="../disc/MLG0014.html" >Geometrie</a></td>
// <td><a href="../cadre/siiu.html" >Lect. SIMION Iulian</a></td>
// </tr>
// <tr align=center>
// <td>Marti</td>
// <td class="bloc">16-18</td>
// <td>sapt. 1</td>
// <td><a href="../sali/phi.html" >phi</a></td>
// <td>711/1</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG0010.html" >Sisteme dinamice</a></td>
// <td><a href="../cadre/alfl.html" >Drd. Albisoru Florin</a></td>
// </tr>
// <tr align=center>
// <td>Marti</td>
// <td class="bloc">16-18</td>
// <td>sapt. 2</td>
// <td><a href="../sali/phi.html" >phi</a></td>
// <td>711/2</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG0010.html" >Sisteme dinamice</a></td>
// <td><a href="../cadre/alfl.html" >Drd. Albisoru Florin</a></td>
// </tr>
// <tr align=center>
// <td>Miercuri</td>
// <td class="bloc">8-10</td>
// <td>&nbsp;</td>
// <td><a href="../sali/NTTSocrate.html" >NTTSocrate</a></td>
// <td>IG1</td>
// <td>Curs</td>
// <td><a href="../disc/MLG5022.html" >Structuri de date si algoritmi</a></td>
// <td><a href="../cadre/trdi.html" >Lect. CRISTEA Diana</a></td>
// </tr>
// <tr align=center>
// <td>Miercuri</td>
// <td class="bloc">10-12</td>
// <td>&nbsp;</td>
// <td><a href="../sali/NTTSocrate.html" >NTTSocrate</a></td>
// <td>IG1</td>
// <td>Curs</td>
// <td><a href="../disc/MLG0010.html" >Sisteme dinamice</a></td>
// <td><a href="../cadre/viad.html" >Lect. VIOREL Adrian</a></td>
// </tr>
// <tr align=center>
// <td>Miercuri</td>
// <td class="bloc">14-16</td>
// <td>sapt. 2</td>
// <td><a href="../sali/A323.html" >A323</a></td>
// <td>711</td>
// <td>Seminar</td>
// <td><a href="../disc/MLG5022.html" >Structuri de date si algoritmi</a></td>
// <td><a href="../cadre/trdi.html" >Lect. CRISTEA Diana</a></td>
// </tr>
// <tr align=center>
// <td>Miercuri</td>
// <td class="bloc">16-18</td>
// <td>sapt. 2</td>
// <td><a href="../sali/A322.html" >A322</a></td>
// <td>711</td>
// <td>Seminar</td>
// <td><a href="../disc/MLG5025.html" >Algoritmica grafelor</a></td>
// <td><a href="../cadre/joad.html" >C.d.asociat JOSAN Adela</a></td>
// </tr>
// <tr align=center>
// <td>Joi</td>
// <td class="bloc">10-12</td>
// <td>&nbsp;</td>
// <td><a href="../sali/NTTSocrate.html" >NTTSocrate</a></td>
// <td>IG1</td>
// <td>Curs</td>
// <td><a href="../disc/MLG5025.html" >Algoritmica grafelor</a></td>
// <td><a href="../cadre/sach.html" >Conf. SACAREA Christian</a></td>
// </tr>
// <tr align=center>
// <td>Joi</td>
// <td class="bloc">14-16</td>
// <td>&nbsp;</td>
// <td><a href="../sali/Multimedia.html" >Multimedia</a></td>
// <td>711/1</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG5006.html" >Programare orientata obiect</a></td>
// <td><a href="../cadre/ruca.html" >Lect. RUSU Catalin</a></td>
// </tr>
// <tr align=center>
// <td>Joi</td>
// <td class="bloc">16-18</td>
// <td>sapt. 1</td>
// <td><a href="../sali/phi.html" >phi</a></td>
// <td>711/1</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG5022.html" >Structuri de date si algoritmi</a></td>
// <td><a href="../cadre/sovi.html" >C.d.asociat SOLEA Victor</a></td>
// </tr>
// <tr align=center>
// <td>Joi</td>
// <td class="bloc">18-20</td>
// <td>sapt. 1</td>
// <td><a href="../sali/Discovery.html" >Discovery</a></td>
// <td>711/1</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG5025.html" >Algoritmica grafelor</a></td>
// <td><a href="../cadre/sach.html" >Conf. SACAREA Christian</a></td>
// </tr>
// <tr align=center>
// <td>Joi</td>
// <td class="bloc">18-20</td>
// <td>sapt. 2</td>
// <td><a href="../sali/Discovery.html" >Discovery</a></td>
// <td>711/2</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG5025.html" >Algoritmica grafelor</a></td>
// <td><a href="../cadre/sach.html" >Conf. SACAREA Christian</a></td>
// </tr>
// <tr align=center>
// <td>Joi</td>
// <td class="bloc">18-20</td>
// <td>sapt. 1</td>
// <td><a href="../sali/phi.html" >phi</a></td>
// <td>711/2</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG5022.html" >Structuri de date si algoritmi</a></td>
// <td><a href="../cadre/sovi.html" >C.d.asociat SOLEA Victor</a></td>
// </tr>
// <tr align=center>
// <td>Vineri</td>
// <td class="bloc">8-10</td>
// <td>&nbsp;</td>
// <td><a href="../sali/NTTSocrate.html" >NTTSocrate</a></td>
// <td>IG1</td>
// <td>Curs</td>
// <td><a href="../disc/MLG0014.html" >Geometrie</a></td>
// <td><a href="../cadre/siiu.html" >Lect. SIMION Iulian</a></td>
// </tr>
// <tr align=center>
// <td>Vineri</td>
// <td class="bloc">14-16</td>
// <td>&nbsp;</td>
// <td><a href="../sali/5-I.html" >5/I</a></td>
// <td>IG1</td>
// <td>Curs</td>
// <td><a href="../disc/MLG5006.html" >Programare orientata obiect</a></td>
// <td><a href="../cadre/ruca.html" >Lect. RUSU Catalin</a></td>
// </tr>
// <tr align=center>
// <td>Vineri</td>
// <td class="bloc">16-18</td>
// <td>sapt. 1</td>
// <td><a href="../sali/A321.html" >A321</a></td>
// <td>711</td>
// <td>Seminar</td>
// <td><a href="../disc/MLG5006.html" >Programare orientata obiect</a></td>
// <td><a href="../cadre/giho.html" >C.d.asociat GIURGIU Horia</a></td>
// </tr>
// </table>
// <h1>Grupa 712</h1>
// <table border=1 cellspacing=0 cellpadding=0>
// <tr align=center>
// <th>Ziua</th>
// <th>Orele</th>
// <th>Frecventa</th>
// <th>Sala</th>
// <th>Formatia</th>
// <th>Tipul</th>
// <th>Disciplina</th>
// <th>Cadrul didactic</th>
// </tr>
// <tr align=center>
// <td>Luni</td>
// <td class="bloc">12-14</td>
// <td>sapt. 1</td>
// <td><a href="../sali/C310.html" >C310</a></td>
// <td>712</td>
// <td>Seminar</td>
// <td><a href="../disc/MLG5007.html" >Sisteme de operare</a></td>
// <td><a href="../cadre/mida.html" >Lect. MIRCEA Ioan Gabriel</a></td>
// </tr>
// <tr align=center>
// <td>Luni</td>
// <td class="bloc">14-16</td>
// <td>&nbsp;</td>
// <td><a href="../sali/L001.html" >L001</a></td>
// <td>712/1</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG5007.html" >Sisteme de operare</a></td>
// <td><a href="../cadre/tead.html" >Drd. Telcian Adrian</a></td>
// </tr>
// <tr align=center>
// <td>Luni</td>
// <td class="bloc">16-18</td>
// <td>&nbsp;</td>
// <td><a href="../sali/L001.html" >L001</a></td>
// <td>712/2</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG5007.html" >Sisteme de operare</a></td>
// <td><a href="../cadre/tead.html" >Drd. Telcian Adrian</a></td>
// </tr>
// <tr align=center>
// <td>Luni</td>
// <td class="bloc">16-18</td>
// <td>&nbsp;</td>
// <td><a href="../sali/L307.html" >L307</a></td>
// <td>IG1</td>
// <td>Laborator</td>
// <td><a href="../disc/MLR2002.html" >Metode avansate de rezolvare a problemelor de matematica si informatica</a></td>
// <td><a href="../cadre/mida.html" >Lect. MIRCEA Ioan Gabriel</a></td>
// </tr>
// <tr align=center>
// <td>Luni</td>
// <td class="bloc">18-20</td>
// <td>&nbsp;</td>
// <td><a href="../sali/C310.html" >C310</a></td>
// <td>IG1</td>
// <td>Curs</td>
// <td><a href="../disc/MLR2002.html" >Metode avansate de rezolvare a problemelor de matematica si informatica</a></td>
// <td><a href="../cadre/mida.html" >Lect. MIRCEA Ioan Gabriel</a></td>
// </tr>
// <tr align=center>
// <td>Marti</td>
// <td class="bloc">8-10</td>
// <td>&nbsp;</td>
// <td><a href="../sali/NTTSocrate.html" >NTTSocrate</a></td>
// <td>IG1</td>
// <td>Curs</td>
// <td><a href="../disc/MLG5007.html" >Sisteme de operare</a></td>
// <td><a href="../cadre/drsa.html" >Conf. AVRAM Sanda</a></td>
// </tr>
// <tr align=center>
// <td>Marti</td>
// <td class="bloc">10-12</td>
// <td>sapt. 2</td>
// <td><a href="../sali/A313.html" >A313</a></td>
// <td>712</td>
// <td>Seminar</td>
// <td><a href="../disc/MLG0010.html" >Sisteme dinamice</a></td>
// <td><a href="../cadre/viad.html" >Lect. VIOREL Adrian</a></td>
// </tr>
// <tr align=center>
// <td>Marti</td>
// <td class="bloc">12-14</td>
// <td>&nbsp;</td>
// <td><a href="../sali/A323.html" >A323</a></td>
// <td>712</td>
// <td>Seminar</td>
// <td><a href="../disc/MLG0014.html" >Geometrie</a></td>
// <td><a href="../cadre/siiu.html" >Lect. SIMION Iulian</a></td>
// </tr>
// <tr align=center>
// <td>Marti</td>
// <td class="bloc">18-20</td>
// <td>sapt. 1</td>
// <td><a href="../sali/phi.html" >phi</a></td>
// <td>712/1</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG0010.html" >Sisteme dinamice</a></td>
// <td><a href="../cadre/alfl.html" >Drd. Albisoru Florin</a></td>
// </tr>
// <tr align=center>
// <td>Marti</td>
// <td class="bloc">18-20</td>
// <td>sapt. 2</td>
// <td><a href="../sali/phi.html" >phi</a></td>
// <td>712/2</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG0010.html" >Sisteme dinamice</a></td>
// <td><a href="../cadre/alfl.html" >Drd. Albisoru Florin</a></td>
// </tr>
// <tr align=center>
// <td>Miercuri</td>
// <td class="bloc">8-10</td>
// <td>&nbsp;</td>
// <td><a href="../sali/NTTSocrate.html" >NTTSocrate</a></td>
// <td>IG1</td>
// <td>Curs</td>
// <td><a href="../disc/MLG5022.html" >Structuri de date si algoritmi</a></td>
// <td><a href="../cadre/trdi.html" >Lect. CRISTEA Diana</a></td>
// </tr>
// <tr align=center>
// <td>Miercuri</td>
// <td class="bloc">10-12</td>
// <td>&nbsp;</td>
// <td><a href="../sali/NTTSocrate.html" >NTTSocrate</a></td>
// <td>IG1</td>
// <td>Curs</td>
// <td><a href="../disc/MLG0010.html" >Sisteme dinamice</a></td>
// <td><a href="../cadre/viad.html" >Lect. VIOREL Adrian</a></td>
// </tr>
// <tr align=center>
// <td>Miercuri</td>
// <td class="bloc">14-16</td>
// <td>sapt. 1</td>
// <td><a href="../sali/A323.html" >A323</a></td>
// <td>712</td>
// <td>Seminar</td>
// <td><a href="../disc/MLG5022.html" >Structuri de date si algoritmi</a></td>
// <td><a href="../cadre/trdi.html" >Lect. CRISTEA Diana</a></td>
// </tr>
// <tr align=center>
// <td>Miercuri</td>
// <td class="bloc">18-20</td>
// <td>sapt. 1</td>
// <td><a href="../sali/A322.html" >A322</a></td>
// <td>712</td>
// <td>Seminar</td>
// <td><a href="../disc/MLG5025.html" >Algoritmica grafelor</a></td>
// <td><a href="../cadre/joad.html" >C.d.asociat JOSAN Adela</a></td>
// </tr>
// <tr align=center>
// <td>Joi</td>
// <td class="bloc">8-10</td>
// <td>&nbsp;</td>
// <td><a href="../sali/phi.html" >phi</a></td>
// <td>712/2</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG5006.html" >Programare orientata obiect</a></td>
// <td><a href="../cadre/crio.html" >Drd. Crisan Ioan</a></td>
// </tr>
// <tr align=center>
// <td>Joi</td>
// <td class="bloc">10-12</td>
// <td>&nbsp;</td>
// <td><a href="../sali/NTTSocrate.html" >NTTSocrate</a></td>
// <td>IG1</td>
// <td>Curs</td>
// <td><a href="../disc/MLG5025.html" >Algoritmica grafelor</a></td>
// <td><a href="../cadre/sach.html" >Conf. SACAREA Christian</a></td>
// </tr>
// <tr align=center>
// <td>Joi</td>
// <td class="bloc">14-16</td>
// <td>sapt. 1</td>
// <td><a href="../sali/Saturn.html" >Saturn</a></td>
// <td>712/1</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG5025.html" >Algoritmica grafelor</a></td>
// <td><a href="../cadre/sach.html" >Conf. SACAREA Christian</a></td>
// </tr>
// <tr align=center>
// <td>Joi</td>
// <td class="bloc">14-16</td>
// <td>sapt. 2</td>
// <td><a href="../sali/Saturn.html" >Saturn</a></td>
// <td>712/2</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG5025.html" >Algoritmica grafelor</a></td>
// <td><a href="../cadre/sach.html" >Conf. SACAREA Christian</a></td>
// </tr>
// <tr align=center>
// <td>Joi</td>
// <td class="bloc">16-18</td>
// <td>&nbsp;</td>
// <td><a href="../sali/Multimedia.html" >Multimedia</a></td>
// <td>712/1</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG5006.html" >Programare orientata obiect</a></td>
// <td><a href="../cadre/ruca.html" >Lect. RUSU Catalin</a></td>
// </tr>
// <tr align=center>
// <td>Joi</td>
// <td class="bloc">16-18</td>
// <td>sapt. 2</td>
// <td><a href="../sali/phi.html" >phi</a></td>
// <td>712/2</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG5022.html" >Structuri de date si algoritmi</a></td>
// <td><a href="../cadre/sovi.html" >C.d.asociat SOLEA Victor</a></td>
// </tr>
// <tr align=center>
// <td>Joi</td>
// <td class="bloc">18-20</td>
// <td>sapt. 2</td>
// <td><a href="../sali/phi.html" >phi</a></td>
// <td>712/1</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG5022.html" >Structuri de date si algoritmi</a></td>
// <td><a href="../cadre/sovi.html" >C.d.asociat SOLEA Victor</a></td>
// </tr>
// <tr align=center>
// <td>Vineri</td>
// <td class="bloc">8-10</td>
// <td>&nbsp;</td>
// <td><a href="../sali/NTTSocrate.html" >NTTSocrate</a></td>
// <td>IG1</td>
// <td>Curs</td>
// <td><a href="../disc/MLG0014.html" >Geometrie</a></td>
// <td><a href="../cadre/siiu.html" >Lect. SIMION Iulian</a></td>
// </tr>
// <tr align=center>
// <td>Vineri</td>
// <td class="bloc">14-16</td>
// <td>&nbsp;</td>
// <td><a href="../sali/5-I.html" >5/I</a></td>
// <td>IG1</td>
// <td>Curs</td>
// <td><a href="../disc/MLG5006.html" >Programare orientata obiect</a></td>
// <td><a href="../cadre/ruca.html" >Lect. RUSU Catalin</a></td>
// </tr>
// <tr align=center>
// <td>Vineri</td>
// <td class="bloc">16-18</td>
// <td>sapt. 2</td>
// <td><a href="../sali/A321.html" >A321</a></td>
// <td>712</td>
// <td>Seminar</td>
// <td><a href="../disc/MLG5006.html" >Programare orientata obiect</a></td>
// <td><a href="../cadre/giho.html" >C.d.asociat GIURGIU Horia</a></td>
// </tr>
// </table>
// <h1>Grupa 713</h1>
// <table border=1 cellspacing=0 cellpadding=0>
// <tr align=center>
// <th>Ziua</th>
// <th>Orele</th>
// <th>Frecventa</th>
// <th>Sala</th>
// <th>Formatia</th>
// <th>Tipul</th>
// <th>Disciplina</th>
// <th>Cadrul didactic</th>
// </tr>
// <tr align=center>
// <td>Luni</td>
// <td class="bloc">10-12</td>
// <td>sapt. 2</td>
// <td><a href="../sali/C510.html" >C510</a></td>
// <td>713</td>
// <td>Seminar</td>
// <td><a href="../disc/MLG5007.html" >Sisteme de operare</a></td>
// <td><a href="../cadre/mida.html" >Lect. MIRCEA Ioan Gabriel</a></td>
// </tr>
// <tr align=center>
// <td>Luni</td>
// <td class="bloc">12-14</td>
// <td>&nbsp;</td>
// <td><a href="../sali/L307.html" >L307</a></td>
// <td>713/2</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG5006.html" >Programare orientata obiect</a></td>
// <td><a href="../cadre/gnse.html" >C.d.asociat GNANDT Sebastian</a></td>
// </tr>
// <tr align=center>
// <td>Luni</td>
// <td class="bloc">14-16</td>
// <td>&nbsp;</td>
// <td><a href="../sali/L307.html" >L307</a></td>
// <td>713/1</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG5006.html" >Programare orientata obiect</a></td>
// <td><a href="../cadre/gnse.html" >C.d.asociat GNANDT Sebastian</a></td>
// </tr>
// <tr align=center>
// <td>Luni</td>
// <td class="bloc">16-18</td>
// <td>&nbsp;</td>
// <td><a href="../sali/L307.html" >L307</a></td>
// <td>IG1</td>
// <td>Laborator</td>
// <td><a href="../disc/MLR2002.html" >Metode avansate de rezolvare a problemelor de matematica si informatica</a></td>
// <td><a href="../cadre/mida.html" >Lect. MIRCEA Ioan Gabriel</a></td>
// </tr>
// <tr align=center>
// <td>Luni</td>
// <td class="bloc">18-20</td>
// <td>&nbsp;</td>
// <td><a href="../sali/C310.html" >C310</a></td>
// <td>IG1</td>
// <td>Curs</td>
// <td><a href="../disc/MLR2002.html" >Metode avansate de rezolvare a problemelor de matematica si informatica</a></td>
// <td><a href="../cadre/mida.html" >Lect. MIRCEA Ioan Gabriel</a></td>
// </tr>
// <tr align=center>
// <td>Marti</td>
// <td class="bloc">8-10</td>
// <td>&nbsp;</td>
// <td><a href="../sali/NTTSocrate.html" >NTTSocrate</a></td>
// <td>IG1</td>
// <td>Curs</td>
// <td><a href="../disc/MLG5007.html" >Sisteme de operare</a></td>
// <td><a href="../cadre/drsa.html" >Conf. AVRAM Sanda</a></td>
// </tr>
// <tr align=center>
// <td>Marti</td>
// <td class="bloc">10-12</td>
// <td>&nbsp;</td>
// <td><a href="../sali/A322.html" >A322</a></td>
// <td>713</td>
// <td>Seminar</td>
// <td><a href="../disc/MLG0014.html" >Geometrie</a></td>
// <td><a href="../cadre/siiu.html" >Lect. SIMION Iulian</a></td>
// </tr>
// <tr align=center>
// <td>Marti</td>
// <td class="bloc">12-14</td>
// <td>sapt. 1</td>
// <td><a href="../sali/A313.html" >A313</a></td>
// <td>713</td>
// <td>Seminar</td>
// <td><a href="../disc/MLG0010.html" >Sisteme dinamice</a></td>
// <td><a href="../cadre/viad.html" >Lect. VIOREL Adrian</a></td>
// </tr>
// <tr align=center>
// <td>Marti</td>
// <td class="bloc">16-18</td>
// <td>sapt. 1</td>
// <td><a href="../sali/L321.html" >L321</a></td>
// <td>713/2</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG5022.html" >Structuri de date si algoritmi</a></td>
// <td><a href="../cadre/sovi.html" >C.d.asociat SOLEA Victor</a></td>
// </tr>
// <tr align=center>
// <td>Marti</td>
// <td class="bloc">16-18</td>
// <td>&nbsp;</td>
// <td><a href="../sali/L339.html" >L339</a></td>
// <td>713/1</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG5007.html" >Sisteme de operare</a></td>
// <td><a href="../cadre/tead.html" >Drd. Telcian Adrian</a></td>
// </tr>
// <tr align=center>
// <td>Marti</td>
// <td class="bloc">18-20</td>
// <td>&nbsp;</td>
// <td><a href="../sali/L336.html" >L336</a></td>
// <td>713/2</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG5007.html" >Sisteme de operare</a></td>
// <td><a href="../cadre/tead.html" >Drd. Telcian Adrian</a></td>
// </tr>
// <tr align=center>
// <td>Marti</td>
// <td class="bloc">18-20</td>
// <td>sapt. 1</td>
// <td><a href="../sali/L439.html" >L439</a></td>
// <td>713/1</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG5022.html" >Structuri de date si algoritmi</a></td>
// <td><a href="../cadre/sovi.html" >C.d.asociat SOLEA Victor</a></td>
// </tr>
// <tr align=center>
// <td>Miercuri</td>
// <td class="bloc">8-10</td>
// <td>&nbsp;</td>
// <td><a href="../sali/NTTSocrate.html" >NTTSocrate</a></td>
// <td>IG1</td>
// <td>Curs</td>
// <td><a href="../disc/MLG5022.html" >Structuri de date si algoritmi</a></td>
// <td><a href="../cadre/trdi.html" >Lect. CRISTEA Diana</a></td>
// </tr>
// <tr align=center>
// <td>Miercuri</td>
// <td class="bloc">10-12</td>
// <td>&nbsp;</td>
// <td><a href="../sali/NTTSocrate.html" >NTTSocrate</a></td>
// <td>IG1</td>
// <td>Curs</td>
// <td><a href="../disc/MLG0010.html" >Sisteme dinamice</a></td>
// <td><a href="../cadre/viad.html" >Lect. VIOREL Adrian</a></td>
// </tr>
// <tr align=center>
// <td>Miercuri</td>
// <td class="bloc">12-14</td>
// <td>sapt. 1</td>
// <td><a href="../sali/phi.html" >phi</a></td>
// <td>713/1</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG0010.html" >Sisteme dinamice</a></td>
// <td><a href="../cadre/alfl.html" >Drd. Albisoru Florin</a></td>
// </tr>
// <tr align=center>
// <td>Miercuri</td>
// <td class="bloc">12-14</td>
// <td>sapt. 2</td>
// <td><a href="../sali/phi.html" >phi</a></td>
// <td>713/2</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG0010.html" >Sisteme dinamice</a></td>
// <td><a href="../cadre/alfl.html" >Drd. Albisoru Florin</a></td>
// </tr>
// <tr align=center>
// <td>Miercuri</td>
// <td class="bloc">16-18</td>
// <td>sapt. 2</td>
// <td><a href="../sali/A323.html" >A323</a></td>
// <td>713</td>
// <td>Seminar</td>
// <td><a href="../disc/MLG5022.html" >Structuri de date si algoritmi</a></td>
// <td><a href="../cadre/trdi.html" >Lect. CRISTEA Diana</a></td>
// </tr>
// <tr align=center>
// <td>Miercuri</td>
// <td class="bloc">18-20</td>
// <td>sapt. 2</td>
// <td><a href="../sali/A322.html" >A322</a></td>
// <td>713</td>
// <td>Seminar</td>
// <td><a href="../disc/MLG5025.html" >Algoritmica grafelor</a></td>
// <td><a href="../cadre/joad.html" >C.d.asociat JOSAN Adela</a></td>
// </tr>
// <tr align=center>
// <td>Joi</td>
// <td class="bloc">10-12</td>
// <td>&nbsp;</td>
// <td><a href="../sali/NTTSocrate.html" >NTTSocrate</a></td>
// <td>IG1</td>
// <td>Curs</td>
// <td><a href="../disc/MLG5025.html" >Algoritmica grafelor</a></td>
// <td><a href="../cadre/sach.html" >Conf. SACAREA Christian</a></td>
// </tr>
// <tr align=center>
// <td>Joi</td>
// <td class="bloc">16-18</td>
// <td>sapt. 1</td>
// <td><a href="../sali/Saturn.html" >Saturn</a></td>
// <td>713/1</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG5025.html" >Algoritmica grafelor</a></td>
// <td><a href="../cadre/sach.html" >Conf. SACAREA Christian</a></td>
// </tr>
// <tr align=center>
// <td>Joi</td>
// <td class="bloc">16-18</td>
// <td>sapt. 2</td>
// <td><a href="../sali/Saturn.html" >Saturn</a></td>
// <td>713/2</td>
// <td>Laborator</td>
// <td><a href="../disc/MLG5025.html" >Algoritmica grafelor</a></td>
// <td><a href="../cadre/sach.html" >Conf. SACAREA Christian</a></td>
// </tr>
// <tr align=center>
// <td>Vineri</td>
// <td class="bloc">8-10</td>
// <td>&nbsp;</td>
// <td><a href="../sali/NTTSocrate.html" >NTTSocrate</a></td>
// <td>IG1</td>
// <td>Curs</td>
// <td><a href="../disc/MLG0014.html" >Geometrie</a></td>
// <td><a href="../cadre/siiu.html" >Lect. SIMION Iulian</a></td>
// </tr>
// <tr align=center>
// <td>Vineri</td>
// <td class="bloc">14-16</td>
// <td>&nbsp;</td>
// <td><a href="../sali/5-I.html" >5/I</a></td>
// <td>IG1</td>
// <td>Curs</td>
// <td><a href="../disc/MLG5006.html" >Programare orientata obiect</a></td>
// <td><a href="../cadre/ruca.html" >Lect. RUSU Catalin</a></td>
// </tr>
// <tr align=center>
// <td>Vineri</td>
// <td class="bloc">18-20</td>
// <td>sapt. 1</td>
// <td><a href="../sali/A321.html" >A321</a></td>
// <td>713</td>
// <td>Seminar</td>
// <td><a href="../disc/MLG5006.html" >Programare orientata obiect</a></td>
// <td><a href="../cadre/giho.html" >C.d.asociat GIURGIU Horia</a></td>
// </tr>
// </table>
// </center></body></html>

//   """,
//                   //Optional parameters:
//                   padding: EdgeInsets.all(8.0),
//                   backgroundColor: Colors.white70,
//                   defaultTextStyle: TextStyle(fontFamily: 'serif',fontSize: 5.0),
//                   linkStyle: const TextStyle(
//                     color: Colors.redAccent,
//                     decorationColor: Colors.redAccent,
//                     decoration: TextDecoration.underline,
//                   ),
//                   onLinkTap: (url) {
//                     // open url in a webview
//                   },
//                 ),

                      Text(
                    '..Orar..',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
