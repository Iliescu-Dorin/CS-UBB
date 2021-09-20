import 'dart:async';
import 'dart:io';

import 'package:UBB/Pages/Intro/intro.dart';
import 'package:UBB/Pages/Setari/widget/superhero.dart';
import 'package:UBB/menu_page.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:UBB/zoom_scaffold.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import './Pages/Login/login_page.dart';
import './Pages/Login/home_page.dart';
import 'Pages/Orar/getOrar.dart';
import 'Pages/Stiri/MovieResModel.dart';

void main() {
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(new Splash()));
  // .then((_) => runApp(new MyApp()));
}
// void main() => runApp(new MyApp());

String parseHtmlString(String htmlString) {
  var document = parse(htmlString);

  String parsedString = parse(document.body.text).documentElement.text;

  return parsedString;
}

String spec = "";
String anUniv = "";
String tip = "";
String subGrupa = "";
String grupa = "";
// String saptamana = "";

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student UBB',
      theme: new ThemeData(
        fontFamily: 'Nunito',
      ),
      home: MyMainPage(),
      routes: routes,
    );
  }
}

class MyMainPage extends StatefulWidget {
  // To restart App
  static restartApp(BuildContext context) {
    final _MyMainPageState state =
        context.ancestorStateOfType(const TypeMatcher<_MyMainPageState>());
    state.restartApp();
  }

  @override
  _MyMainPageState createState() => new _MyMainPageState();
}

List posts;
bool loadingPosts;
bool loadingOrar;
bool loadingPerosane;
bool loadingInbox;
List<SuperHero> yourProfesors = new List();
List<String> profIdentityJsonToHtml =
    new List<String>(); //lista Html cu fiecare profesor

class _MyMainPageState extends State<MyMainPage> {
  final String apiUrl = "https://cs.ubbcluj.ro/wp-json/wp/v2/";
  String theme;

  ThemeData light = ThemeData(
    unselectedWidgetColor: Colors.white,
    brightness: Brightness.light,
    primaryColor: Colors.grey[100],
    accentColor: Colors.blue[900],
    backgroundColor: Colors.grey[100],
    textTheme: TextTheme(
      headline: TextStyle(),
      title: TextStyle(),
      body1: TextStyle(),
    ),
  );

  ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    unselectedWidgetColor: Colors.grey[700],
    primaryColor: Colors.black,
    accentColor: Colors.indigo[800],
    backgroundColor: Colors.black,
    textTheme: TextTheme(
      headline: TextStyle(),
      title: TextStyle(),
      body1: TextStyle(),
    ),
  );

//To Restart app
  Key key = UniqueKey();

  restartApp() {
    setState(() {
      key = UniqueKey();
    });
    checkTheme();
  }

  checkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String prefTheme =
        prefs.getString("theme") == null ? "light" : prefs.getString("theme");
    print("THEME: $prefTheme");
    setState(() {
      theme = prefTheme;
    });
  }

  // Future<String> getPosts() async {
  //   var res = await http.get(
  //       Uri.encodeFull(apiUrl + "posts?_embed&categories=24+72+26"),
  //       headers: {"Accept": "application/json"});

  //   var resBody = json.decode(res.body);
  //   posts = resBody;

  //   return "Success!";
  // }

  Future<String> getPosts() async {
    setState(() {
      loadingPosts = true;
    });
    var res = await http.get(
        Uri.encodeFull(apiUrl + "posts?_embed&categories=24+72+26"),
        headers: {"Accept": "application/json"});
    String source = Utf8Decoder().convert(res.bodyBytes);

    var resBody = json.decode(source);
    posts = resBody;
    int code = res.statusCode;
    if (code == 200) {
      loadingPosts = false;
      posts.forEach((f) {
        PostResponse pr = new PostResponse();
        pr.image = f["featured_media"] == 0
            ? 'http://www.cs.ubbcluj.ro/wp-content/themes/CSUBB/images/logo.png'
            //'https://www.ubbcluj.ro/images/logo/logo_cs.png'
            //'https://upload.wikimedia.org/wikipedia/en/d/d6/Babe%C5%9F-Bolyai_University_logo.png'
            // 'http://starubb.institute.ubbcluj.ro/wp-content/uploads/2017/01/Logo-UBB-Traditie-si-Excelenta.png'
            : f["_embedded"]["wp:featuredmedia"][0]["source_url"];
        pr.detalii =
            f["excerpt"]["rendered"].replaceAll(new RegExp(r'<[^>]*>'), '');

        if (f["content"]["rendered"].toString().contains('img src=\"')) {
          RegExp regExp = new RegExp(r'src="(.*?)"');
          pr.contentImage =
              regExp.firstMatch(f["content"]["rendered"]).group(1);
          pr.content =
              f["content"]["rendered"].replaceAll(new RegExp(r'<[^>]*>'), '') ==
                      null
                  ? parseHtmlString(f["excerpt"]["rendered"])
                  : parseHtmlString(f["content"]["rendered"]);
        } else if (f["content"]["rendered"].toString().contains("img src=\'")) {
          RegExp regExp2 = new RegExp(r"src='(.*?)'");
          pr.contentImage =
              regExp2.firstMatch(f["content"]["rendered"]).group(1);
          pr.content =
              f["content"]["rendered"].replaceAll(new RegExp(r'<[^>]*>'), '') ==
                      null
                  ? parseHtmlString(f["excerpt"]["rendered"])
                  : parseHtmlString(f["content"]["rendered"]);
        } else {
          pr.contentImage = "";
          pr.content =
              f["content"]["rendered"].replaceAll(new RegExp(r'<[^>]*>'), '') ==
                      null
                  ? parseHtmlString(f["excerpt"]["rendered"])
                  : parseHtmlString(f["content"]["rendered"]);
        }

        pr.title = f["title"]['rendered'];
        pr.date =
            "${f["date"].toString().substring(8, 10)}/${f["date"].toString().substring(5, 7)}";
        pr.link = f["link"];
        date.add(pr);
      });

      return "Success!";
    } else {
      setState(() {
        loadingPosts = false;
      });
      return "Something went wrong";
    }
  }

  Future<String> getOrar() async {
    setState(() {
      loadingOrar = true;
    });

    SharedPreferences sp = await SharedPreferences.getInstance();
    String _an = sp.getString("an");
    String _subGrupa = sp.getString("subGrupa");
    String _specializare = sp.getString("specializare");
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

    String data;
    var now = new DateTime.now();
    if (now.month >= 10 && now.month <= 12)
      data = "${now.year}-1";
    else if (now.month >= 1 && now.month <= 2)
      data = "${now.year - 1}-1";
    else
      data = "${now.year - 1}-2";
    String htmlOrar =
        "http://www.cs.ubbcluj.ro/files/orar/$data/tabelar/$tip$spec$anUniv.html";

    print(htmlOrar);
    var client = Client();
    String url =
        'http://www.cs.ubbcluj.ro/files/orar/$data/tabelar/$tip$spec$anUniv.html';
    Response response = await client.get(url);
    int code = response.statusCode;
    RegExp exp3 = new RegExp(r"(?<=\. |C.d.asociat )(.*?)(?<=$)");
    if (code == 200) {
      setState(() {
        // try {
        program.clear();
        loadingOrar = false;
        // Use html parser
        var document = parse(response.body);
        var table = document.getElementsByTagName('table');
        var rows = table[int.parse(
                    grupa.toString().substring(grupa.toString().length - 1)) -
                1]
            .getElementsByTagName('tr');
        //  table[int.parse(subGrupa) - 1].getElementsByTagName('tr');

        var cols;
        rows.forEach(
          (r) {
            if (r != rows[0]) {
              cols = r.getElementsByTagName('td');
              Materie intervalOrar = new Materie();
              intervalOrar.zi = cols[0].innerHtml;
              intervalOrar.ora = cols[1].innerHtml;
              intervalOrar.frecventa = cols[2].innerHtml.substring(6);
              intervalOrar.sala =
                  cols[3].innerHtml.replaceAll(new RegExp(r'<[^>]*>'), '');
              intervalOrar.formatia = cols[4].innerHtml;
              intervalOrar.tipul = cols[5].innerHtml;
              intervalOrar.disciplina =
                  cols[6].innerHtml.replaceAll(new RegExp(r'<[^>]*>'), '');
              final matches2 = exp3.firstMatch(
                  cols[7].innerHtml.replaceAll(new RegExp(r'<[^>]*>'), ''));
              intervalOrar.cadrulDidactic = matches2.group(1);
              program.add(intervalOrar);
            }
          },
        );
        // } on Exception catch (_) {
        //   loadingOrar = true;
        // } catch (error) {
        //   loadingOrar = true;
        // }
      });
      return "Success";
    } else {
      setState(() {
        loadingOrar = false;
      });
      return "Something went wrong";
    }
  }

  List<String> profIdentityJsonToHtml =
      new List<String>(); //lista Html cu fiecare profesor
  Future<String> getProfesors() async {
    setState(() {
      loadingPerosane = true;
    });
    String profiMate =
        """<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="wp-image-333 alignnone" title="Agratini Octavian" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/agratini.octavian.jpg" alt="" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. AGRATINI Octavian, <em>Profesor Universitar</em><br/>
E-mail: agratini[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~agratini" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~agratini</a><br/>
Adresa: Mathematica 204, Tel: 6303<br/>
Domenii de interes: Operatori de aproximare, Teoria probabilitatilor</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-11216" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/andrica.dorin_.jpg" alt="Andrica Dorin" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. ANDRICA Dorin, <em>Profesor Universitar</em><br/>
E-mail: dandrica[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://www.dorinandrica.ro/" target="_blank" rel="nofollow noopener noreferrer">http://www.dorinandrica.ro</a><br/>
Adresa: Mathematica 11, Tel: 6306<br/>
Domenii de interes: Calcul pe varietati, Teoria punctelor critice</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-10551" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Breaz-Simion.jpg" alt="Breaz Simion" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. BREAZ Simion, <em>Profesor Universitar</em><br/>
E-mail: bodo[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~bodo" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~bodo</a><br/>
Adresa: Mathematica 216, Tel: 6301<br/>
Domenii de interes: Grupuri abeliene</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-13394" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Crivei-Septimiu.jpg" alt="Crivei Septimiu" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. CRIVEI Septimiu, <em>Profesor Universitar</em><br/>
E-mail: crivei[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~crivei" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~crivei</a><br/>
Adresa: Mathematica 217, Tel: 6301<br/>
Domenii de interes: Teoria modulelor, Teoria categoriilor</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-14931" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/kohr.gabriela.jpg" alt="Kohr Gabriela" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. KOHR Gabriela, <em>Profesor Universitar</em><br/>
E-mail: gkohr[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~gkohr" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~gkohr</a><br/>
Adresa: Mathematica 2, Tel: 6308<br/>
Domenii de interes: Analiza complexa, Teoria geometrica a functiilor de mai multe variabile complexe</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-414" title="Kohr Mirela" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/kohr.mirela.jpg" alt="" width="100" height="124"/></div>
<div style="display: inline-block; width: 490px;">Dr. KOHR Mirela, <em>Profesor Universitar</em><br/>
E-mail: mkohr[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~mkohr" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~mkohr</a><br/>
Adresa: Mathematica 209, Tel: 6312<br/>
Domenii de interes: Mecanica fluidelor, Teoria potentialului, Analiza complexa</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-427" title="Marcus Andrei" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/marcus.andrei.jpg" alt="" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. MARCUS Andrei, <em>Profesor Universitar</em><br/>
E-mail: marcus[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~marcus" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~marcus</a><br/>
Adresa: Mathematica 217, Tel: 6301<br/>
Domenii de interes: Reprezentari ale grupurilor si algebrelor, Algebra omologica</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-16139" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Petrusel-Adrian.jpg" alt="Petrusel Adrian" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. PETRUSEL Adrian, <em>Profesor Universitar</em><br/>
E-mail: petrusel[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~petrusel" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~petrusel</a><br/>
Adresa: Mathematica 108, Tel: 6309<br/>
Domenii de interes: Teoria punctului fix, Analiza operatorilor multivoci, Ecuaţii diferenţiale</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-462" title="Popovici Nicolae" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Popovici-Nicolae.jpg" alt="" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. POPOVICI Nicolae, <em>Profesor Universitar</em><br/>
E-mail: popovici[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~popovici" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~popovici</a><br/>
Adresa: Mathematica 102, Tel: 6305<br/>
Domenii de interes: Analiza matematica, Cercetare operationala</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="aligncenter size-full wp-image-13778" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Precup-Radu.jpg" alt="Precup Radu" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. PRECUP Radu, <em>Profesor Universitar</em><br/>
E-mail: r.precup[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~r.precup" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~r.precup</a><br/>
Adresa: Mathematica 109, Tel: 6309<br/>
Domenii de interes: Analiza neliniara, Ecuatii diferentiale neliniare, Ecuatii cu derivate partiale</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-445" title="Anisiu Valeriu" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Anisiu-Valeriu.jpg" alt="" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. ANISIU Valeriu, <em>Conferentiar Universitar</em><br/>
E-mail: anisiu[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~anisiu" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~anisiu</a><br/>
Adresa: Mathematica 1, Tel: 6308<br/>
Domenii de interes: Analiza reala, Analiza convexa</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-446" title="Blaga Cristina" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Blaga-Cristina.jpg" alt="" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. BLAGA Cristina, <em>Conferentiar Universitar</em><br/>
E-mail: cpblaga[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~cpblaga" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~cpblaga</a><br/>
Adresa: Observatorul Astronomic, Tel: 0264-594592<br/>
Domenii de interes: Problema inversa a dinamicii, Aplicatii ale sistemelor dinamice in astronomie</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-448" title="Blaga Paul" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Blaga-Paul.jpg" alt="" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. BLAGA Paul, <em>Conferentiar Universitar</em><br/>
E-mail: pablaga[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://www.cs.ubbcluj.ro/~pablaga" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~pablaga</a><br/>
Adresa: Mathematica 9, Tel: 6306<br/>
Domenii de interes: Geometrie computationala, Geometrie simplectica</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-21239" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Breckner-Brigitte_small.jpg" alt="Breckner Brigitte" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. BRECKNER Brigitte, <em>Conferentiar Universitar</em><br/>
E-mail: brigitte[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/https://sites.google.com/site/brigittebreckner/links" target="_blank" rel="noopener noreferrer">https://sites.google.com/site/brigittebreckner/links</a><br/>
Adresa: Mathematica 102, Tel: 6305<br/>
Domenii de interes: Teorie Lie, Semigrupuri topologice, Analiza functionala aplicata</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-450" title="Buica Adriana" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Buica-Adriana.jpg" alt="" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. BUICA Adriana, <em>Conferentiar Universitar</em><br/>
E-mail: abuica[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~abuica" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~abuica</a><br/>
Adresa: Mathematica 110, Tel: 6310<br/>
Domenii de interes: Sisteme dinamice, Ecuatii cu derivate partiale</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-436" title="Catinas Teodora" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Catinas-Teodora.jpg" alt="" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. CATINAS Teodora, <em>Conferentiar Universitar</em><br/>
E-mail: tcatinas[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~tcatinas" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~tcatinas</a><br/>
Adresa: Mathematica 205, Tel: 6303<br/>
Domenii de interes: Teoria aproximarii, Metode numerice</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-453" title="Chiorean Ioana" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Chiorean-Ioana.jpg" alt="" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. CHIOREAN Ioana, <em>Conferentiar Universitar</em><br/>
E-mail: ioana[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~ioana" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~ioana</a><br/>
Adresa: Mathematica 206, Tel: 6311<br/>
Domenii de interes: Metode numerice iterative pentru rezolvarea ecuatiilor operatoriale, Calcul paralel</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-16133" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Grosan-Teodor.jpg" alt="Grosan-Teodor" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. GROSAN Teodor, <em>Conferentiar Universitar</em><br/>
E-mail: tgrosan[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~tgrosan" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~tgrosan</a><br/>
Adresa: Mathematica 209, Tel: 6312<br/>
Domenii de interes: Mecanica teoretica, Mecanica fluidelor, Medii poroase, Transfer de caldura</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-16136" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Lisei-Hannelore.jpg" alt="Lisei Hannelore" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. LISEI Hannelore, <em>Conferentiar Universitar</em><br/>
E-mail: hanne[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~hanne" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~hanne</a><br/>
Adresa: Mathematica 206, Tel: 6311<br/>
Domenii de interes: Analiza stochastica</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-24161" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/micula.sanda_.jpg" alt="Sanda Micula" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. MICULA Sanda, <em>Conferentiar Universitar</em><br/>
E-mail: smicula[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~smicula" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~smicula</a><br/>
Adresa: Mathematica 207, Tel: 6311<br/>
Domenii de interes: Metode numerice pentru ecuatii integrale</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-7956" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Modoi-George-Ciprian.jpg" alt="Modoi George Ciprian" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. MODOI George Ciprian, <em>Conferentiar Universitar</em><br/>
E-mail: cmodoi[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://algebra.math.ubbcluj.ro/~modoi" target="_blank" rel="noopener noreferrer">http://algebra.math.ubbcluj.ro/~modoi</a><br/>
Adresa: Mathematica 217, Tel: 6301<br/>
Domenii de interes: Categorii abeliene si triangulate, Algebra omologica</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-17204" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Pelea-Cosmin-133x100.jpg" alt="Pelea Cosmin" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. PELEA Cosmin, <em>Conferentiar Universitar</em><br/>
E-mail: cpelea[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~cpelea" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~cpelea</a><br/>
Adresa: Mathematica 216, Tel: 6301<br/>
Domenii de interes: Multialgebre</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-13756" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Pintea-Cornel.jpg" alt="Pintea Cornel" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. PINTEA Cornel, <em>Conferentiar Universitar</em><br/>
E-mail: cpintea[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~cpintea" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~cpintea</a><br/>
Adresa: Mathematica 9, Tel: 6306<br/>
Domenii de interes: Geometrie, Topologie diferentiala, Topologie algebrica, Puncte critice</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Rosca Natalia" alt="Rosca Natalia" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Rosca-Natalia.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. ROSCA Natalia, <em>Conferentiar Universitar</em><br/>
E-mail: natalia[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~natalia" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~natalia</a><br/>
Adresa: Mathematica 205, Tel: 6303<br/>
Domenii de interes: Metode numerice, Teoria probabilitatilor, Statistica matematica</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-15410" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Serban-Marcel.jpg" alt="Serban Marcel" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. SERBAN Marcel, <em>Conferentiar Universitar</em><br/>
E-mail: mserban[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~mserban" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~mserban</a><br/>
Adresa: Mathematica 110, Tel: 6310<br/>
Domenii de interes: Ecuatii diferentiale</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-24980" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Trimbitas-Radu.jpg" alt="Trimbitas Radu" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. TRIMBITAS Radu, <em>Conferentiar Universitar</em><br/>
E-mail: tradu[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~tradu" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~tradu</a><br/>
Adresa: Mathematica 206, Tel: 6311<br/>
Domenii de interes: Complexitatea calculului, Statistica matematica</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-15874" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Trif-Tiberiu.jpg" alt="Trif Tiberiu" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. TRIF Tiberiu, <em>Conferentiar Universitar</em><br/>
E-mail: ttrif[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~ttrif" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~ttrif</a><br/>
Adresa: Mathematica 106, Tel: 6302<br/>
Domenii de interes: Analiza convexa, Ecuatii functionale</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-466" title="Berinde Stefan" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Berinde-Stefan.jpg" alt="" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. BERINDE Stefan, <em>Lector Universitar</em><br/>
E-mail: sberinde[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~sberinde" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~sberinde</a><br/>
Adresa: Mathematica 102, Tel: 6305<br/>
Domenii de interes: Analiza matematica, Mecanica cereasca</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Bota Monica" alt="Bota Monica" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Bota-Monica.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. BOTA Monica Felicia, <em>Lector Universitar</em><br/>
E-mail: bmonica[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~bmonica" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~bmonica</a><br/>
Adresa: Mathematica 110, Tel: 6310<br/>
Domenii de interes: Ecuatii diferentiale</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-479" title="Grad Anca" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Grad-Anca.jpg" alt="" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. GRAD Anca, <em>Lector Universitar</em><br/>
E-mail: ancagrad[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~ancagrad" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~ancagrad</a><br/>
Adresa: Mathematica 107, Tel: 6304<br/>
Domenii de interes: Optimizare, Analiza convexa</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-471" title="Ilea Veronica" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Ilea-Veronica.jpg" alt="" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. ILEA Veronica, <em>Lector Universitar</em><br/>
E-mail: vdarzu[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~vdarzu" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~vdarzu</a><br/>
Adresa: Mathematica 110, Tel: 6310<br/>
Domenii de interes: Ecuatii diferentiale</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Nicolae-Adriana" alt="Nicolae-Adriana" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Nicolae-Adriana.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. NICOLAE Adriana, <em>Lector Universitar</em><br/>
E-mail: anicolae[at]math.ubbcluj.ro<br/>
Web:<br/>
Adresa: Mathematica 115, Tel: 6310<br/>
Domenii de interes: Analiza matematica</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Iulian Simion" alt="Iulian Simion" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Iulian-Simion.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. SIMION Iulian, <em>Lector Universitar</em><br/>
E-mail: simion[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~simion" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~simion</a><br/>
Adresa: Mathematica 9, Tel: 6306<br/>
Domenii de interes: Teorie Lie, Grupuri reductive</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-13741" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Vacaretu-Daniel.jpg" alt="Vacaretu Daniel" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. VACARETU Daniel, <em>Lector Universitar</em><br/>
E-mail: vacaretu[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~vacaretu" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~vacaretu</a><br/>
Adresa: Mathematica 11, Tel: 6306<br/>
Domenii de interes: Complemente de geometrie, Geometrie diferentiala</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Alecsa Cristian" alt="Alecsa Cristian" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Alecsa-Cristian.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Drd. ALECSA Cristian, <em>Asistent Universitar</em><br/>
E-mail: cristian.alecsa[at]math.ubbcluj.ro<br/>
Web:<br/>
Adresa:, Tel:<br/>
Domenii de interes: Teoria punctului fix, Analiza operatorilor multivoci, Ecuații diferențiale</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Iancu Mihai" alt="Iancu Mihai" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Iancu-Mihai.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. IANCU Mihai, <em>Asistent Universitar</em><br/>
E-mail: miancu[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~miancu" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~miancu</a><br/>
Adresa:, Tel:<br/>
Domenii de interes: Analiză complexă</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Micu Tudor" alt="Micu Tudor" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Micu-Tudor.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Drd. MICU Tudor, <em>Asistent Universitar</em><br/>
E-mail: micu[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~micu" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~micu</a><br/>
Adresa: , Tel:<br/>
Domenii de interes: Geometrie aritmetică, Teoria numerelor</div>
</div>
<h2>Profesori universitari emeriţi</h2>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Blaga Petru" alt="Blaga Petru" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Blaga-Petru.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. BLAGA Petru, <em>Profesor Universitar Emerit</em><br/>
E-mail: blaga[at]math.ubbcluj.ro<br/>
Web:<br/>
Adresa: Mathematica 204, Tel: 6303<br/>
Domenii de interes: Metode numerice si statistice, Teorial aproximarii</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-17208" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Breckner-Wolfgang-133x100.jpg" alt="Breckner Wolfgang" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. BRECKNER Wolfgang, <em>Profesor Universitar Emerit</em><br/>
E-mail: breckner[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~breckner" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~breckner</a><br/>
Adresa: Mathematica 106, Tel: 6302<br/>
Domenii de interes: Analiza functionala, Teoria optimizarii</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-17211" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Calugareanu-Grigore-133x100.jpg" alt="Calugareanu Grigore" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. CALUGAREANU Grigore, <em>Profesor Universitar Emerit</em><br/>
E-mail: calu[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~calu" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~calu</a><br/>
Adresa: Mathematica 215, Tel: 6301<br/>
Domenii de interes: Grupuri abeliene, Algebre comutative</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Cobzas Stefan" alt="Cobzas Stefan" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Cobzas-Stefan-133x100.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. COBZAS Stefan, <em>Profesor Universitar Emerit</em><br/>
E-mail: scobzas[at]math.ubbcluj.ro<br/>
Web:<br/>
Adresa: , Tel:<br/>
Domenii de interes:</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-17221" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Coman-Gheorghe-133x100.jpg" alt="Coman Gheorghe" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. COMAN Gheorghe, <em>Profesor Universitar Emerit</em><br/>
E-mail: ghcoman[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~ghcoman" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~ghcoman</a><br/>
Adresa: Mathematica 204, Tel: 6303<br/>
Domenii de interes: Aproximare, Analiza numerica</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-9756" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/duca.dorel_.jpg" alt="Duca Dorel" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. DUCA Dorel, <em>Profesor Universitar Emerit</em><br/>
E-mail: dduca[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://math.ubbcluj.ro/~dduca" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~dduca</a><br/>
Adresa: Mathematica 106, Tel: 6302<br/>
Domenii de interes: Cercetare operationala, Teoria optimizarii</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Lupsa Liana" alt="Lupsa Liana" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Lupsa-Liana-133x100.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. LUPSA Liana, <em>Profesor Universitar Emerit</em><br/>
E-mail: llupsa[at]math.ubbcluj.ro<br/>
Web:<br/>
Adresa: Mathematica 106, Tel: 6302<br/>
Domenii de interes: Optimizare multicriteriala, Cercetare operationala</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-438" title="Muresan Marian" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Muresan-Marian.jpg" alt="" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. MURESAN Marian, <em>Profesor Universitar Emerit</em><br/>
E-mail: mmarian[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://marianmuresan.wordpress.com/" target="_blank" rel="nofollow noopener noreferrer">http://marianmuresan.wordpress.com</a><br/>
Adresa: Mathematica 105, Tel: 6305<br/>
Domenii de interes: Control optimal, Analiza neneteda</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Titus Petrila" alt="Titus Petrila" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Titus-Petrila.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. PETRILA Titus, <em>Profesor Universitar Emerit</em><br/>
E-mail:<br/>
Web:<br/>
Adresa: , Tel:<br/>
Domenii de interes: Modelare matematica in hidroaerodinamica, Metode numerice si computationale in dinamica fluidelor si studii multidisciplinare</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Pop Ioan" alt="Pop Ioan" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Pop-Ioan-133x100.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. POP Ioan, <em>Profesor Universitar Emerit</em><br/>
E-mail: ipop[at]math.ubbcluj.ro<br/>
Web:<br/>
Adresa: Mathematica 203, Tel:<br/>
Domenii de interes: Mecanica fluidelor, Transfer de caldura, Strat limita, Metode numerice</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Purdea Ioan" alt="Purdea Ioan" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Purdea-Ioan-133x100.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. PURDEA Ioan, <em>Profesor Universitar Emerit</em><br/>
E-mail:<br/>
Web:<br/>
Adresa: Mathematica 216, Tel: 6301<br/>
Domenii de interes: Algebre universale, Multialgebre</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-22571" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Rus-A.-Ioan.jpg" alt="Rus A. Ioan" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. RUS A. Ioan, <em>Membru de onoare al Academiei, Profesor Universitar Emerit</em><br/>
E-mail: iarus[at]math.ubbcluj.ro<br/>
Web:<br/>
Adresa: Mathematica 108, Tel: 6309<br/>
Domenii de interes: Ecuatii diferentiale, Teoria punctului fix</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Salagean Grigore" alt="Salagean Grigore" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Salagean-Grigore.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. SALAGEAN Grigore, <em>Profesor Universitar Emerit</em><br/>
E-mail: salagean[at]math.ubbcluj.ro<br/>
Web:<br/>
Adresa: Mathematica 3, Tel: 6308<br/>
Domenii de interes: Analiza complexa, Teoria geometrica a functiilor</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-23933" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Ureche-Vasile.jpg" alt="Vasile Ureche" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. URECHE Vasile, <em>Profesor Universitar Emerit</em><br/>
E-mail: vureche[at]math.ubbcluj.ro<br/>
Web:<br/>
Adresa:<br/>
Domenii de interes: Astronomie, Astrofizică</div>
</div>
<h2>Profesori invitaţi</h2>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Gheorghe Morosanu" alt="Gheorghe Morosanu" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Gheorghe-Morosanu-133x100.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. MOROŞANU Gheorghe, <em>Profesor Universitar Asociat Invitat</em><br/>
E-mail: morosanug[at]ceu.edu<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://people.ceu.edu/gheorghe_morosanu" target="_blank" rel="nofollow noopener noreferrer">http://people.ceu.edu/gheorghe_morosanu</a><br/>
Adresa: 1051 Budapest, Zrinyi u. 14, 3rd floor, office #310<br/>
Domenii de interes: Ecuaţii diferenţiale şi cu diferenţe, Calcul variaţional, Ecuaţii de evoluţie în spaţii Banach, Teoria perturbaţiilor singulare, Teme de matematică aplicată</div>
</div>
<h2>Cercetători / colaboratori</h2>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Zamfirescu Carol" alt="Zamfirescu Carol" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Zamfirescu-Carol.png"/></div>
<div style="display: inline-block; width: 490px;">
Dr. ZAMFIRESCU Carol, Universitatea Ghent, Belgia<br/>
E-mail: czamfirescu[at]gmail.com<br/>
Web: <a href="https://web.archive.org/web/20190703091426/http://czamfirescu.tricube.de/" target="_blank" rel="noopener nofollow noreferrer">http://czamfirescu.tricube.de/</a><br/>
Adresa: Departamentul de Matematici Aplicate, Informatică şi Statistica, Universitatea Ghent, Krijgslaan 281 &#8211; S9, 9000 Ghent, Belgia<br/>
Domenii de interes: Teoria grafurilor, Geometrie discreta</div>
</div>
<h2>Doctoranzi</h2>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Albisoru Andrei-Florin" alt="Albisoru Andrei-Florin" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Albisoru-Andrei-Florin-100x133.jpg"/></div>
<div style="display: inline-block; width: 490px;">
ALBISORU Andrei-Florin, <em>Doctorand</em><br/>
E-mail: florin.albisoru[at]math.ubbcluj.ro<br/>
Web:<br/>
Adresa:, Tel:<br/>
Domenii de interes: Mecanica fluidelor, Teoria potentialului, Ecuatii cu derivate partiale</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Corina Blidar" alt="Corina Blidar" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Corina-Blidar.jpg"/></div>
<div style="display: inline-block; width: 490px;">
BLIDAR Corina, <em>Doctorand</em><br/>
E-mail: corina.blidar[at]math.ubbcluj.ro<br/>
Web:<br/>
Adresa:, Tel:<br/>
Domenii de interes: Optimizare, Teoria jocurilor</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Boros Imre" alt="Boros Imre" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Boros-Imre.jpg"/></div>
<div style="display: inline-block; width: 490px;">
BOROŞ Imre, <em>Doctorand</em><br/>
E-mail: imre.boros[at]math.ubbcluj.ro<br/>
Web:<br/>
Adresa:, Tel:<br/>
Domenii de interes: Metode numerice</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-3912" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Bungardi-Sandra.jpg" alt="Bungardi Sandra" width="96" height="96"/></div>
<div style="display: inline-block; width: 490px;">BUNGARDI Sandra, <em>Doctorand</em><br/>
E-mail: sandrab[at]math.ubbcluj.ro<br/>
Web:<br/>
Adresa:, Tel:<br/>
Domenii de interes: Controlul optimal</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Andrada Cimpean" alt="Andrada Cimpean" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Andrada-Cimpean.jpg"/></div>
<div style="display: inline-block; width: 490px;">
CIMPEAN Andrada, <em>Doctorand</em><br/>
E-mail: andrada.c[at]math.ubbcluj.ro<br/>
Web:<br/>
Adresa:, Tel:<br/>
Domenii de interes: Inele si module</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Silviu Grapini" alt="Silviu Grapini" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/silviu.grapini.jpg"/></div>
<div style="display: inline-block; width: 490px;">
GRAPINI Silviu, <em>Doctorand</em><br/>
E-mail: silviu.grapini[at]math.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Teoria aproximarii, Analiza wavelet</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Robert Gutt" alt="Robert Gutt" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Robert-Gutt-small.jpg"/></div>
<div style="display: inline-block; width: 490px;">
GUTT Robert, <em>Doctorand</em><br/>
E-mail: robert.gutt[at]math.ubbcluj.ro<br/>
Web:<br/>
Adresa:, Tel:<br/>
Domenii de interes: Mecanica fluidelor, Teoria Potențialului, Analiză complexă</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Anamaria Indrea" alt="Anamaria Indrea" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Indrea-Anamaria.jpg"/></div>
<div style="display: inline-block; width: 490px;">
INDREA Anamaria, <em>Doctorand</em><br/>
E-mail:<br/>
Web:<br/>
Adresa:, Tel:<br/>
Domenii de interes:</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Lorinczi Abel" alt="Lorinczi Abel" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Lorinczi-Abel.jpg"/></div>
<div style="display: inline-block; width: 490px;">
LŐRINCZI Ábel, <em>Doctorand</em><br/>
E-mail: lorinczi[at]math.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Teoria reprezentării algebrelor finit dimensionale</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Manu Andra" alt="Manu Andra" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Manu-Andra.jpg"/></div>
<div style="display: inline-block; width: 490px;">
MANU Andra, <em>Doctorand</em><br/>
E-mail: andra.manu[at]math.ubbcluj.ro<br/>
Web:<br/>
Adresa:, Tel:<br/>
Domenii de interes: Analiză complexă</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Minuta Aurelian" alt="Minuta Aurelian" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Minuta-Aurelian.jpg"/></div>
<div style="display: inline-block; width: 490px;">
MINUŢĂ Virgilius-Aurelian, <em>Doctorand</em><br/>
E-mail: minuta.aurelian[at]math.ubbcluj.ro<br/>
Web:<br/>
Adresa:, Tel:<br/>
Domenii de interes: Reprezentari ale grupurilor si algebrelor</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Naicu Cosmina" alt="Naicu Cosmina" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Naicu-Cosmina.jpg"/></div>
<div style="display: inline-block; width: 490px;">
NAICU Cosmina, <em>Doctorand</em><br/>
E-mail:<br/>
Web:<br/>
Adresa:, Tel:<br/>
Domenii de interes: Analiza complexa</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-22523" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Anca-Oprea.jpg" alt="Anca Oprea" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">OPREA Anca, <em>Doctorand</em><br/>
E-mail:<br/>
Web:<br/>
Adresa:, Tel:<br/>
Domenii de interes: Operatori neliniari si ecuatii diferentiale, Teoria punctului fix</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Nicolae Valentin Papara" alt="Nicolae Valentin Papara" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Nicolae-Valentin-Papara.jpg"/></div>
<div style="display: inline-block; width: 490px;">
PAPARA Nicolae Valentin, <em>Doctorand</em><br/>
E-mail: nvpapara[at]math.ubbcluj.ro<br/>
Web:<br/>
Adresa:, Tel:<br/>
Domenii de interes: Mecanica fluidelor</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Parajdi Lorand" alt="Parajdi Lorand" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Parajdi-Lorand.jpg"/></div>
<div style="display: inline-block; width: 490px;">
PARAJDI Lorand, <em>Doctorand</em><br/>
E-mail: lorand[at]cs.ubbcluj.ro<br/>
Web:<br/>
Adresa:, Tel:<br/>
Domenii de interes: Ecuații diferențiale, Modelare matematică aplicată</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="" alt="" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/missing-male-133x100.jpg"/></div>
<div style="display: inline-block; width: 490px;">
PÂRVA Oana-Maria, <em>Doctorand</em><br/>
E-mail: oana.parva[at]math.ubbcluj.ro<br/>
Web:<br/>
Adresa:, Tel:<br/>
Domenii de interes: Analiza Complexă, Funcții univalente</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Pall-Szabo Agnes Orsolya" alt="Pall-Szabo Agnes Orsolya" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Pall-Szabo-Agnes-Orsolya.jpg"/></div>
<div style="display: inline-block; width: 490px;">
PÁLL-SZABÓ Ágnes Orsolya, <em>Doctorand</em><br/>
E-mail: pallszaboagnes[at]math.ubbcluj.ro<br/>
Web:<br/>
Adresa:, Tel:<br/>
Domenii de interes: Analiza complexă, Teoria geometrică a funcţiilor</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Radu Simona Maria" alt="Radu Simona Maria" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Radu-Simona-Maria.jpg"/></div>
<div style="display: inline-block; width: 490px;">
RADU Simona-Maria, <em>Doctorand</em><br/>
E-mail: simonamariar[at]math.ubbcluj.ro<br/>
Web:<br/>
Adresa:, Tel:<br/>
Domenii de interes: Module și categorii</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Andreea Sandor" alt="Andreea Sandor" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Andreea-Sandor.jpg"/></div>
<div style="display: inline-block; width: 490px;">
SANDOR Andreea, <em>Doctorand</em><br/>
E-mail: andreea.sandor[at]math.ubbcluj.ro<br/>
Web:<br/>
Adresa:, Tel:<br/>
Domenii de interes:</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Szatmari Eszter" alt="Szatmari Eszter" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Szatmari-Eszter.jpg"/></div>
<div style="display: inline-block; width: 490px;">
SZATMARI Eszter, <em>Doctorand</em><br/>
E-mail: szatmari.eszter[at]math.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Analiză complexă, Teoria geometrică a funcţiilor</div>
</div>
<h2>Personal didactic auxiliar</h2>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-11500" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Bonda-Georgeta.jpg" alt="Bonda Georgeta" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">BONDA Georgeta, <em>Tehnician</em><br/>
E-mail: gbonda[at]math.ubbcluj.ro<br/>
Adresa: Cladirea Centrala, Tel: 5242</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-11554" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Liviu-Mircea.jpg" alt="Liviu Mircea" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">MIRCEA Liviu, <em>Tehnician</em><br/>
E-mail: mirliviu[at]math.ubbcluj.ro<br/>
Adresa: Observatorul Astronomic, Tel: 0264-594592</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-7959" src="https://web.archive.org/web/20190703091426im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Mesesan-Ana.jpg" alt="Mesesan Ana" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">MESESAN Ana, <em>Secretara</em><br/>
E-mail: amesesan[at]math.ubbcluj.ro<br/>
Adresa: Cladirea Centrala, Tel: 5242</div>
</div>""";
    String profiInfo = """<div style="text-align: right;">
<h3>director: Prof. Dr. ANDREICA Anca</h3>
</div>
<h2>Cadre didactice titulare</h2>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-17243" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Andreica-Anca-133x100.jpg" alt="Andreica Anca" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. ANDREICA Anca, <em>Profesor Universitar</em><br/>
E-mail: anca[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~anca" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~anca</a><br/>
Adresa: Campus 406, Tel:<br/>
Domenii de interes: Calcul evolutiv, Retele complexe, Automate celulare</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-583" title="Czibula Gabriela" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Czibula-Gabriela.jpg" alt="" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. CZIBULA Gabriela, <em>Profesor Universitar</em><br/>
E-mail: gabis[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~gabis" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~gabis</a><br/>
Adresa: Campus 440, Tel: 5815<br/>
Domenii de interes: Inteligenţa computaţională aplicată, Instruire automata, Sisteme multiagent</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-610" title="Czibula Istvan" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Czibula-Istvan.jpg" alt="" width="100" height="103"/></div>
<div style="display: inline-block; width: 490px;">Dr. CZIBULA Istvan, <em>Profesor Universitar</em><br/>
E-mail: istvanc[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~istvanc" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~istvanc</a><br/>
Adresa: Campus 404, Tel:<br/>
Domenii de interes: Ingineria soft bazata pe cautare, Inteligenta artificiala</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Diosan Laura" alt="Diosan Laura" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Diosan-Laura-300x400.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. DIOSAN Laura, <em>Profesor Universitar</em><br/>
E-mail: lauras[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~lauras" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~lauras</a><br/>
Adresa: Campus 404, Tel:<br/>
Domenii de interes: Inteligenta artificiala, Calcul evolutiv, Instruire automata</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-14709" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Pop-F.-Horia.jpg" alt="Horia F. Pop" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. POP F. Horia, <em>Profesor Universitar</em><br/>
E-mail: hfpop[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~hfpop" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~hfpop</a><br/>
Adresa: Campus 342, Tel: 5807<br/>
Domenii de interes: Intelligent Data Analysis, Soft Computing, Inteligenta artificiala</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Sanda Avram" alt="Sanda Avram" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Sanda-Avram.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. AVRAM Sanda, <em>Conferentiar Universitar</em><br/>
E-mail: sanda[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~sanda" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~sanda</a><br/>
Adresa: Campus 406, Tel:<br/>
Domenii de interes: Programare web, Analiză conceptuală formală</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-20410" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Boian-Rares-133x100.jpg" alt="Boian Rares" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. BOIAN Rares, <em>Conferentiar Universitar</em><br/>
E-mail: rares[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~rares" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~rares</a><br/>
Adresa: Campus 304, Tel: 5827<br/>
Domenii de interes: Realitate virtuala</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Chira Camelia" alt="Chira Camelia" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Chira-Camelia.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. CHIRA Camelia, <em>Conferentiar Universitar</em><br/>
E-mail: cchira[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~cchira" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~cchira</a><br/>
Adresa: Campus 333, Tel: 5815<br/>
Domenii de interes: Calcul evolutiv, Metaeuristici inspirate de natura, Sisteme complexe</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-25772" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Grigoreta-Cojocar.jpg" alt="Grigoreta Cojocar" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. COJOCAR Grigoreta, <em>Conferentiar Universitar</em><br/>
E-mail: grigo[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~grigo" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~grigo</a><br/>
Adresa: Campus 404, Tel:<br/>
Domenii de interes: Software engineering, Programarea orientata pe aspecte, Aspect mining</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-7765" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Craciun-Florin.jpg" alt="Craciun Florin" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. CRACIUN Florin, <em>Conferentiar Universitar</em><br/>
E-mail: craciunf[at]cs.ubbcluj.ro<br/>
Web:<br/>
Adresa:, Tel:<br/>
Domenii de interes: Analiza si verificarea automata a programelor, Sisteme de tipuri, Limbaje de programare</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-13979" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Darabant-Sergiu.jpg" alt="Darabant Sergiu" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. DARABANT Sergiu Adrian, <em>Conferentiar Universitar</em><br/>
E-mail: dadi[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~dadi" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~dadi</a><br/>
Adresa: Campus, Tel:<br/>
Domenii de interes: Procesarea imaginilor, Deep Learning, Instruire automata, Retele convolutionale, Sisteme distribuite, Baze de date</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-17371" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Motogna-Simona-133x100.jpg" alt="Motogna Simona" width="100" height="134"/></div>
<div style="display: inline-block; width: 490px;">Dr. MOTOGNA Simona, <em>Conferentiar Universitar</em><br/>
E-mail: motogna[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~motogna" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~motogna</a><br/>
Adresa: Campus 342, Tel: 5807<br/>
Domenii de interes: Limbaje formale si metode de proiectare a compilatoarelor, Semantica limbajelor</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-14698" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Niculescu-Virginia.jpg" alt="Niculescu Virginia" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. NICULESCU Virginia, <em>Conferentiar Universitar</em><br/>
E-mail: vniculescu[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~vniculescu" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~vniculescu</a><br/>
Adresa: Campus 342, Tel: 5807<br/>
Domenii de interes: Calcul paralel, Programare orientata obiect</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Christian Sacarea" alt="Christian Sacarea" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Christian-Sacarea-133x100.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. SACAREA Christian, <em>Conferentiar Universitar</em><br/>
E-mail: csacarea[at]math.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://math.ubbcluj.ro/~csacarea" target="_blank" rel="noopener noreferrer">http://math.ubbcluj.ro/~csacarea</a><br/>
Adresa: Mathematica 216, Tel: 6301<br/>
Domenii de interes: Analiza conceptuala formala, Criptografie</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-600" title="Vescan Andreea" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Vescan-Andreea.jpg" alt="" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. VESCAN Andreea, <em>Conferentiar Universitar</em><br/>
E-mail: avescan[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~avescan" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~avescan</a><br/>
Adresa: Campus 404, Tel:<br/>
Domenii de interes: Ingineria programarii, Dezvoltarea bazata pe componente, Metode formale</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Iulian Benta" alt="Iulian Benta" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Iulian-Benta.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. BENTA Iulian, <em>Lector Universitar</em><br/>
E-mail: benta[at]cs.ubbcluj.ro<br/>
Web:<br/>
Adresa: , Tel:<br/>
Domenii de interes: Calcul afectiv, Calcul omniprezent, Instruire automată, Calcul pentru dispozitive mobile, Interacțiune om-calculator</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Iuliana Bocicor" alt="Iuliana Bocicor" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Iuliana-Bocicor.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. BOCICOR Maria Iuliana, <em>Lector Universitar</em><br/>
E-mail: iuliana[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~iuliana/" target="_blank" rel="noopener noreferrer">www.cs.ubbcluj.ro/~iuliana/</a><br/>
Adresa: Campus 440, Tel:<br/>
Domenii de interes: Inteligenta artificiala, Instruire automata, Bioinformatica</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-580" title="Bufnea Darius" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Bufnea-Darius.jpg" alt="" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. BUFNEA Darius, <em>Lector Universitar</em><br/>
E-mail: bufny[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~bufny" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~bufny</a><br/>
Adresa: Campus 304, Tel: 5829<br/>
Domenii de interes: Reţele de calculatoare, Controlul congestiei, Tehnologii web, SEO, Securitatea în Internet</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="" alt="" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/missing-male-133x100.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. CHISALITA-CRETU Camelia, <em>Lector Universitar</em><br/>
E-mail: cretu[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~cretu" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~cretu</a><br/>
Adresa: Campus 404, Tel:<br/>
Domenii de interes: Software Engineering, Programare orientata obiect, Refactoring</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-589" title="Cioban Vasile" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Cioban-Vasile.jpg" alt="" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. CIOBAN Vasile, <em>Lector Universitar</em><br/>
E-mail: vcioban[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~vcioban" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~vcioban</a><br/>
Adresa: Campus 332, Tel: 5815<br/>
Domenii de interes: Sisteme deschise, Baze de date</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Ciuciu Ioana" alt="Ciuciu Ioana" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Ciuciu-Ioana.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. CIUCIU Ioana, <em>Lector Universitar</em><br/>
E-mail: oana[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~oana" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~oana</a><br/>
Adresa: Campus 404, Tel:<br/>
Domenii de interes: Reprezentarea hibrida a cunostintelor, ontologii, interoperabilitate semantica, regasirea informatiei, analiza si vizualizarea Big Data, HCI, utilizabilitate</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-12144" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Cobarzan-Claudiu.jpg" alt="Cobarzan Claudiu" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. COBARZAN Claudiu, <em>Lector Universitar</em><br/>
E-mail: claudiu[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~claudiu" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~claudiu</a><br/>
Adresa: Campus 406, Tel:<br/>
Domenii de interes:</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Cojocar Dan" alt="Cojocar Dan" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Cojocar-Dan.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. COJOCAR Dan, <em>Lector Universitar</em><br/>
E-mail: dan[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~dan" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~dan</a><br/>
Adresa: Campus 406, Tel:<br/>
Domenii de interes: Sisteme distribuite, Programare concurenta</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-12718" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Troanca-Diana.jpg" alt="Cristea Diana" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. CRISTEA Diana, <em>Lector Universitar</em><br/>
E-mail: dianat[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~dianat" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~dianat</a><br/>
Adresa:, Tel:<br/>
Domenii de interes: Analiza conceptuală formală, Programarea concurentă şi distribuită</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-6325" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Radu-Dragos.jpg" alt="Radu Dragos" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. DRAGOS Radu, <em>Lector Universitar</em><br/>
E-mail: radu.dragos[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~radu.dragos" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~radu.dragos</a><br/>
Adresa:, Tel:<br/>
Domenii de interes: Reţele de calculatoare, Administrarea reţelelor şi a sistemelor de calcul</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Gaceanu Radu" alt="Gaceanu Radu" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Gaceanu-Radu.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. GACEANU Radu, <em>Lector Universitar</em><br/>
E-mail: rgaceanu[at]cs.ubbcluj.ro<br/>
Web:<br/>
Adresa: , Tel:<br/>
Domenii de interes: Intelligent Data Analysis, Inteligenta artificiala, Limbaje de programare</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-608" title="Grebla Horea" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Grebla-Horea.jpg" alt="" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. GREBLA Horea, <em>Lector Universitar</em><br/>
E-mail: horea[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~horea" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~horea</a><br/>
Adresa: Campus 406, Tel:<br/>
Domenii de interes: Baze de date, Sisteme distribuite, Sisteme informatice integrate</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-612" title="Guran Adriana" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Guran-Adriana.jpg" alt="" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. GURAN Adriana, <em>Lector Universitar</em><br/>
E-mail: adriana[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~adriana" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~adriana</a><br/>
Adresa: Campus 404, Tel:<br/>
Domenii de interes: Proiectare centrata pe utilizator, Utilizabilitate, OOP</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Ionescu Vlad" alt="Ionescu Vlad" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Ionescu-Vlad.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. IONESCU Vlad, <em>Lector Universitar</em><br/>
E-mail: ivlad[at]cs.ubbcluj.ro<br/>
Web:<br/>
Adresa:, Tel:<br/>
Domenii de interes: Machine Learning, Software Engineering, Sentiment Analysis</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-627" title="Lazar Ioan" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Lazar-Ioan.jpg" alt="" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. LAZAR Ioan, <em>Lector Universitar</em><br/>
E-mail: ilazar[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~ilazar" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~ilazar</a><br/>
Adresa: Campus 342, Tel: 5807<br/>
Domenii de interes: Metode numerice pentru ecuatii integrale neliniare, Limbaje de programare</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="" alt="" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/missing-male-133x100.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. LUPEA Mihaiela, <em>Lector Universitar</em><br/>
E-mail: lupea[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~lupea" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~lupea</a><br/>
Adresa: Campus 440, Tel: 5815<br/>
Domenii de interes: Logici clasice si neclasice, Modelarea rationamentului, OOP</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-622" title="Lupsa Dana" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Lupsa-Dana.jpg" alt="" width="100" height="115"/></div>
<div style="display: inline-block; width: 490px;">Dr. LUPSA Dana, <em>Lector Universitar</em><br/>
E-mail: dana[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~dana" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~dana</a><br/>
Adresa: Campus 440, Tel: 5815<br/>
Domenii de interes: Prelucrarea limbajului natural, Limbaje de programare</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-614" title="Lupsa Radu" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Lupsa-Radu.jpg" alt="" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. LUPSA Radu, <em>Lector Universitar</em><br/>
E-mail: rlupsa[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~rlupsa" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~rlupsa</a><br/>
Adresa: Campus 304, Tel: 5829<br/>
Domenii de interes: Tehnici de programare, Procesarea imaginilor</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Mihoc Tudor" alt="Mihoc Tudor" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Mihoc-Tudor.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. MIHOC Tudor, <em>Lector Universitar</em><br/>
E-mail: mihoct[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~mihoct/" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~mihoct/</a><br/>
Adresa: Campus 404, Tel:<br/>
Domenii de interes: Teoria jocurilor, Inteligenta artificiala</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Mircea Gabriel" alt="Mircea Gabriel" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Mircea-Gabriel-small.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. MIRCEA Ioan-Gabriel, <em>Lector Universitar</em><br/>
E-mail: mircea[at]cs.ubbcluj.ro<br/>
Web:<br/>
Adresa:, Tel:<br/>
Domenii de interes: Instruire automată, Inteligenţă artificială, Bioinformatică, Bioarheologie</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Arthur Molnar" alt="Arthur Molnar" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Arthur-Molnar.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. MOLNAR Arthur, <em>Lector Universitar</em><br/>
E-mail: arthur[at]cs.ubbcluj.ro<br/>
Web:<br/>
Adresa: , Tel:<br/>
Domenii de interes:</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Marian Zsuzsanna" alt="Marian Zsuzsanna" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Marian-Zsuzsanna.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. ONEȚ-MARIAN Zsuzsanna Edit, <em>Lector Universitar</em><br/>
E-mail: marianzsu[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~marianzsu" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~marianzsu</a><br/>
Adresa:, Tel:<br/>
Domenii de interes:</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-630" title="Petrascu Vladiela" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Petrascu-Vladiela.jpg" alt="" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. PETRASCU Vladiela, <em>Lector Universitar</em><br/>
E-mail: vladi[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~vladi" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~vladi</a><br/>
Adresa: Campus 404, Tel:<br/>
Domenii de interes: Ingineria programarii, Metode formale</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-599" title="Pop Andreea-Diana" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Mihis-Andreea.jpg" alt="" width="97" height="129"/></div>
<div style="display: inline-block; width: 490px;">Dr. POP Andreea-Diana, <em>Lector Universitar</em><br/>
E-mail: mihis[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~mihis" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~mihis</a><br/>
Adresa: Campus 404, Tel:<br/>
Domenii de interes: Metode formale, Prelucrarea limbajului natural</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-618" title="Prejmerean Vasile" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Prejmerean-Vasile.jpg" alt="" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. PREJMEREAN Vasile, <em>Lector Universitar</em><br/>
E-mail: per[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~per" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~per</a><br/>
Adresa: Campus 332, Tel: 5815<br/>
Domenii de interes: Algoritmi si programare, Prelucrarea imaginilor</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Rusu Catalin" alt="Rusu Catalin" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Rusu-Catalin.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. RUSU Catalin, <em>Lector Universitar</em><br/>
E-mail: rusu[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~rusu" target="_blank" rel="nofollow noopener noreferrer">http://www.cs.ubbcluj.ro/~rusu</a><br/>
Adresa:, Tel:<br/>
Domenii de interes: Retele neuronale cu pulsuri, Neurobotica, Inteligenta artificiala</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-3887" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Serban-Camelia.jpg" alt="Şerban Camelia" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. ŞERBAN Camelia, <em>Lector Universitar</em><br/>
E-mail: camelia[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~camelia" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~camelia</a><br/>
Adresa: Campus 404, Tel:<br/>
Domenii de interes: Analiza si proiectarea orientata obiect, Metrici soft</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-615" title="Sterca Adrian" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Sterca-Adrian.jpg" alt="" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. STERCA Adrian, <em>Lector Universitar</em><br/>
E-mail: forest[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~forest" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~forest</a><br/>
Adresa: Campus 406, Tel:<br/>
Domenii de interes:</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-9749" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Suciu-Dan.jpg" alt="Suciu Dan" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. SUCIU Dan Mircea, <em>Lector Universitar</em><br/>
E-mail: tzutzu[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~tzutzu" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~tzutzu</a><br/>
Adresa: Campus, Tel:<br/>
Domenii de interes: Baze de date, Gestiunea proiectelor</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Suciu Mihai" alt="Suciu Mihai" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Suciu-Mihai.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. SUCIU Mihai, <em>Lector Universitar</em><br/>
E-mail: mihai-suciu[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~mihai-suciu" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~mihai-suciu</a><br/>
Adresa:, Tel:<br/>
Domenii de interes: Inteligenta artificiala, Optimizare evolutiva multi-obiectiv, Teoria jocurilor si aplicatii</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Sabina Surdu" alt="Sabina Surdu" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Sabina-Surdu.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. SURDU Sabina, <em>Lector Universitar</em><br/>
E-mail: sabina[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~sabina" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~sabina</a><br/>
Adresa:, Tel:<br/>
Domenii de interes: Baze de date, Algoritmi, Limbaje formale</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-24983" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Trimbitas-Gabriela.jpg" alt="Trimbitas Gabriela" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. TRIMBITAS Gabriela, <em>Lector Universitar</em><br/>
E-mail: gabitr[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~gabitr" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~gabitr</a><br/>
Adresa: Campus 333, Tel: 5815<br/>
Domenii de interes: Baze de date, Structuri de date</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-15736" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Vancea-Alexandru.jpg" alt="Vancea Alexandru" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. VANCEA Alexandru, <em>Lector Universitar</em><br/>
E-mail: vancea[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~vancea" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~vancea</a><br/>
Adresa: Campus 304, Tel: 5829<br/>
Domenii de interes: Paralelizarea automata a programelor, Analiza si proiectarea limbajelor de programare</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-12606" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/ioan-badarinza.jpg" alt="Ioan Badarinza" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. BADARINZA Ioan, <em>Asistent Universitar</em><br/>
E-mail: ionutb[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes:</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Coroiu Adriana" alt="Coroiu Adriana" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Coroiu-Adriana.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. COROIU Adriana Mihaela, <em>Asistent Universitar</em><br/>
E-mail: adrianac[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~adrianac" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~adrianac</a><br/>
Adresa:, Tel:<br/>
Domenii de interes: Inteligenţă computaţională, Agenţi inteligenţi, Analiză conceptuală formală</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Cristina Mihaila" alt="Cristina Mihaila" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Cristina-Mihaila.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. MIHAILA Cristina, <em>Asistent Universitar</em><br/>
E-mail: cristina.mihaila[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~cristina.mihaila" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~cristina.mihaila</a><br/>
Adresa: Campus 404, Tel:<br/>
Domenii de interes: Alocarea sarcinilor si resurselor, Calcul evolutiv</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Pop Emilia" alt="Pop Emilia" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Pop-Emilia.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. POP Emilia, <em>Asistent Universitar</em><br/>
E-mail: emilia[at]cs.ubbcluj.ro<br/>
Adresa: , Tel:<br/>
Domenii de interes: Baze de date, Big Data, Optimizare vectoriala</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Adela Rus" alt="Adela Rus" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Adela-Rus.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. RUS Adela, <em>Asistent Universitar</em><br/>
E-mail: adela[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~adela" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~adela</a><br/>
Adresa:, Tel:<br/>
Domenii de interes: Inteligenta artificiala, Instruire automata</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-15809" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Diana-Halita.jpg" alt="Diana Halita" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. ŞOTROPA Diana-Florina, <em>Asistent Universitar</em><br/>
E-mail: diana.sotropa[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~diana.sotropa" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~diana.sotropa</a><br/>
Adresa:, Tel:<br/>
Domenii de interes: Programare web, Tehnologii web, Analiză conceptuală formală</div>
</div>
<h2>Profesori universitari emeriţi</h2>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-566" title="Parv Bazil" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Parv-Bazil.jpg" alt="" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. PARV Bazil, <em>Profesor Universitar Emerit</em><br/>
E-mail: bparv[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~bparv" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~bparv</a><br/>
Adresa: Cladirea Centrala, centrul MOS, S14, Tel: 5254<br/>
Domenii de interes: Inginerie software, Modelare si simulare, Calcul stiintific</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-561" title="Boian Florian" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Boian-Florian.jpg" alt="" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. BOIAN Florian, <em>Profesor Universitar Emerit</em><br/>
E-mail: florin[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~florin" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~florin</a><br/>
Adresa: Campus 304, Tel: 5829<br/>
Domenii de interes: Sisteme de operare, Programare concurenta si distribuita</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Frentiu Militon" alt="Frentiu Militon" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Frentiu-Militon.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. FRENTIU Militon, <em>Profesor Universitar Emerit</em><br/>
E-mail: mfrentiu[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~mfrentiu" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~mfrentiu</a><br/>
Adresa: Campus 342, Tel: 5807<br/>
Domenii de interes: Metodologia programarii, Modele de simulare</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-16150" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Grigor-Moldovan.jpg" alt="Grigor Moldovan" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. MOLDOVAN Grigor, <em>Profesor Universitar Emerit</em><br/>
E-mail: moldovan[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~moldovan" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~moldovan</a><br/>
Adresa: Campus 333, Tel: 5815<br/>
Domenii de interes: Sisteme distribuite, Limbaje formale si automate</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-23937" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Tambulea-Leon-133x100.jpg" alt="Leon Tambulea" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. TAMBULEA Leon, <em>Profesor Universitar Emerit</em><br/>
E-mail: leon[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~leon" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~leon</a><br/>
Adresa: Campus 333, Tel: 5815<br/>
Domenii de interes: Baze de date, Grafica pe calculator</div>
</div>
<h2>Profesori invitaţi</h2>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;">
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Radu Boţ" alt="Radu Boţ" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Radu-Bot.jpg"/></div>
<div style="display: inline-block; width: 490px;">
Dr. BOŢ Radu Ioan, <em>Profesor Universitar Asociat Invitat</em><br/>
E-mail: radu.bot[at]univie.ac.at<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.mat.univie.ac.at/~rabot/" target="_blank" rel="nofollow noopener noreferrer">http://www.mat.univie.ac.at/~rabot/</a><br/>
Adresa: , Tel:<br/>
Domenii de interes: Algoritmi numerici de optimizare, Procesarea imaginilor, Masini cu suport vectorial</div>
<h2>Cadre didactice asociate</h2>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-17239" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Chiorean-Dan-133x100.jpg" alt="Chiorean Dan" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">Dr. CHIOREAN Dan, <em>Conferentiar Universitar</em><br/>
E-mail: chiorean[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~chiorean" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~chiorean</a><br/>
Adresa: Campus 605, Tel:<br/>
Domenii de interes: Ingineria programării bazată pe modele, Instrumente CASE care sprijină dezvoltarea folosind modele, OCL, Dezvoltare folosind limbaje specifice domeniului şi/sau limbaje adaptate, Metodologii de dezvoltare</div>
</div>
<h2>Doctoranzi</h2>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Silvana Albert" alt="Silvana Albert" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Silvana-Albert.jpg"/></div>
<div style="display: inline-block; width: 490px;">
ALBERT Silvana, <em>Doctorand</em><br/>
E-mail: albert.silvana[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~albert.silvana/home.html" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~albert.silvana/home.html</a><br/>
Domenii de interes: Bioinformatică, Inteligenţă artificială, Inginerie Software</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Andor Camelia-Florina" alt="Andor Camelia-Florina" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Andor-Camelia-Florina.jpg"/></div>
<div style="display: inline-block; width: 490px;">
ANDOR Camelia-Florina, <em>Doctorand</em><br/>
E-mail: andorcamelia[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Big Data</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="" alt="" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/missing-male-133x100.jpg"/></div>
<div style="display: inline-block; width: 490px;">
BORODI Flavia, <em>Doctorand</em><br/>
E-mail: flavia[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Gestiunea proiectelor, Arhitectura sistemelor software</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Florentin Bota" alt="Florentin Bota" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Florentin-Bota.jpg"/></div>
<div style="display: inline-block; width: 490px;">
BOTA Florentin, <em>Doctorand</em><br/>
E-mail: botaflorentin[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~botaflorentin" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~botaflorentin</a><br/>
Domenii de interes: Inteligență artificială, Economie comportamentală, Simulări multi-agent, Deep learning</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="" alt="" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/missing-male-133x100.jpg"/></div>
<div style="display: inline-block; width: 490px;">
BOŢA Daniel, <em>Doctorand</em><br/>
E-mail: dbota[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Detectarea aplicatiilor malware, Data mining, Securitatea informatica</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-15807" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Alina-Calin.jpg" alt="Alina Calin" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">CALIN Alina Delia, <em>Doctorand</em><br/>
E-mail: alinacalin[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~alinacalin/" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~alinacalin</a><br/>
Domenii de interes:</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Ioan Crisan" alt="Ioan Crisan" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Ioan-Crisan.jpg"/></div>
<div style="display: inline-block; width: 490px;">
CRISAN Ioan, <em>Doctorand</em><br/>
E-mail: ioan.crisan[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Software Engineering, Enterprise Systems, Software Architecture and Design</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Daniela Cristea" alt="Daniela Cristea" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Daniela-Cristea.jpg"/></div>
<div style="display: inline-block; width: 490px;">
CRISTEA Daniela Maria, <em>Doctorand</em><br/>
E-mail: danielacristea[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~danielacristea" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~danielacristea</a><br/>
Domenii de interes: Inginerie soft bazata pe agenti, Aspecte mining</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Liana Crivei" alt="Liana Crivei" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Liana-Crivei.jpg"/></div>
<div style="display: inline-block; width: 490px;">
CRIVEI Liana, <em>Doctorand</em><br/>
E-mail: liana.crivei[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Data mining, Baze de date</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Dragos Dobrean" alt="Dragos Dobrean" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Dragos-Dobrean.jpg"/></div>
<div style="display: inline-block; width: 490px;">
DOBREAN Dragoș, <em>Doctorand</em><br/>
E-mail: dobrean[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Arhitecturi software, Platforme mobile</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Alina Enescu" alt="Alina Enescu" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Alina-Enescu.jpg"/></div>
<div style="display: inline-block; width: 490px;">
ENESCU Alina, <em>Doctorand</em><br/>
E-mail: aenescu[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Automate celulare</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Filep Levente" alt="Filep Levente" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Filep-Levente-133x100.jpg"/></div>
<div style="display: inline-block; width: 490px;">
FILEP Levente, <em>Doctorand</em><br/>
E-mail: f.levi[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Cloud computing, Algoritmi meta-euristici, Programare web, Sisteme embedded</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="" alt="" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/missing-male-133x100.jpg"/></div>
<div style="display: inline-block; width: 490px;">
GHEORGHICA Radu, <em>Doctorand</em><br/>
E-mail: gheorghica.radu[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Algoritmica, Programare paralela</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Limboi Sergiu" alt="Limboi Sergiu" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Limboi-Sergiu.jpg"/></div>
<div style="display: inline-block; width: 490px;">
LIMBOI Sergiu, <em>Doctorand</em><br/>
E-mail: sergiu[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Inteligenta artificiala, Arhitecturi orientate pe servicii, Microservices, Search-based software engineering</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Lorincz Beata" alt="Lorincz Beata" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Lorincz-Beata.jpg"/></div>
<div style="display: inline-block; width: 490px;">
LORINCZ Beata, <em>Doctorand</em><br/>
E-mail: lorinczb[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Managementul proiectelor, Inginerie software, Ingineria cerintelor, Baze de date</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Alexandru Marinescu" alt="Alexandru Marinescu" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Alexandru-Marinescu.jpg"/></div>
<div style="display: inline-block; width: 490px;">
MARINESCU Alexandru-Ion, <em>Doctorand</em><br/>
E-mail: amarinescu[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/https://amarinescu.ro/" target="_blank" rel="noopener nofollow noreferrer">https://amarinescu.ro/</a><br/>
Domenii de interes: Inteligenta artificiala, Realitate virtuala</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="" alt="" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/missing-male-133x100.jpg"/></div>
<div style="display: inline-block; width: 490px;">
MIHAI Andrei, <em>Doctorand</em><br/>
E-mail: mihai.andrei[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes:</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Alin Mihis" alt="Alin Mihis" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Alin-Mihis.jpg"/></div>
<div style="display: inline-block; width: 490px;">
MIHIȘ Alin, <em>Doctorand</em><br/>
E-mail: mihis.alin[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Prelucrarea limbajului natural, Ontologii</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Diana Miholca" alt="Diana Miholca" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Diana-Miholca-100x133.jpg"/></div>
<div style="display: inline-block; width: 490px;">
MIHOLCA Diana-Lucia, <em>Doctorand</em><br/>
E-mail: diana[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Inteligență artificială, Instruire automată</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Roxana Mocan" alt="Roxana Mocan" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Roxana-Mocan.jpg"/></div>
<div style="display: inline-block; width: 490px;">
MOCAN Roxana, <em>Doctorand</em><br/>
E-mail: roxanamocan[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Invatare automata, Procesare de imagini</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="" alt="" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/missing-male-133x100.jpg"/></div>
<div style="display: inline-block; width: 490px;">
MONDOC Alexandra, <em>Doctorand</em><br/>
E-mail: alexandra[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Solutii de securitate, Detectia aplicatiilor malitioase bazata pe comportament</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Muresan Horea Bogdan" alt="Muresan Horea Bogdan" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Muresan-Horea-Bogdan.jpg"/></div>
<div style="display: inline-block; width: 490px;">
MURESAN Horea, <em>Doctorand</em><br/>
E-mail: horea.muresan[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Inteligenta artificiala, Retele neuronale convolutionale</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Mursa Bogdan" alt="Mursa Bogdan" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Mursa-Bogdan.jpg"/></div>
<div style="display: inline-block; width: 490px;">
MURSA Bogdan, <em>Doctorand</em><br/>
E-mail: bmursa[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Calcule de inalta performanta, Algoritmi, Extragerea de informatii, Retele complexe</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Maria Nutu" alt="Maria Nutu" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Maria-Nutu.jpg"/></div>
<div style="display: inline-block; width: 490px;">
NUTU Maria, <em>Doctorand</em><br/>
E-mail: maria.nutu[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~maria.nutu/" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~maria.nutu</a><br/>
Domenii de interes: Inteligența artificială, Instruire automată, Intelligent Data Analysis</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Szabolcs Pavel" alt="Szabolcs Pavel" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Szabolcs-Pavel.jpg"/></div>
<div style="display: inline-block; width: 490px;">
PAVEL Szabolcs, <em>Doctorand</em><br/>
E-mail: pszabolcs[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Computer vision, Instruire automată, Deep learning</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Petrusel Mara" alt="Petrusel Mara" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Petrusel-Mara.jpg"/></div>
<div style="display: inline-block; width: 490px;">
PETRUȘEL Mara, <em>Doctorand</em><br/>
E-mail: mara[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Inteligenta artificiala, Sisteme de recomandare</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-9229" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Pop-Bogdan.jpg" alt="Pop Bogdan" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">POP Bogdan, <em>Doctorand</em><br/>
E-mail: popb[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~popb" target="_blank" rel="nofollow noopener noreferrer">http://www.cs.ubbcluj.ro/~popb</a><br/>
Domenii de interes:</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Danut Pop" alt="Danut Pop" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Danut-Pop.jpg"/></div>
<div style="display: inline-block; width: 490px;">
POP Danut, <em>Doctorand</em><br/>
E-mail: danutpop[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Robotica, Inteligenta artificiala, Instruire autonoma</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="" alt="" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/missing-male-133x100.jpg"/></div>
<div style="display: inline-block; width: 490px;">
ROSIAN Vasile Adrian, <em>Doctorand</em><br/>
E-mail: adrian.rosian[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Limbaje de programare, Programare functionala, Teoria categoriilor</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="SAMSUNG CSC" alt="SAMSUNG CSC" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Csanad-Sandor.jpg"/></div>
<div style="display: inline-block; width: 490px;">
SANDOR Csanad, <em>Doctorand</em><br/>
E-mail: scsanad[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Computer vision, Instruirea automata a masinilor, Modele DEEP de instruire automata, Programarea GPU</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Denisa Seghedi" alt="Denisa Seghedi" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Denisa-Seghedi.jpg"/></div>
<div style="display: inline-block; width: 490px;">
SEGHEDI Denisa, <em>Doctorand</em><br/>
E-mail: denisas[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Inteligenta artificiala</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Sima Ioan" alt="Sima Ioan" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Sima-Ioan.jpg"/></div>
<div style="display: inline-block; width: 490px;">
SIMA Ioan, <em>Doctorand</em><br/>
E-mail: sima.ioan[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Baze de date, Bioinformatica</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Cristian-Ioan Stancalau" alt="Cristian-Ioan Stancalau" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Cristian-Ioan-Stancalau.jpg"/></div>
<div style="display: inline-block; width: 490px;">
STANCALAU Cristian-Ioan, <em>Doctorand</em><br/>
E-mail: stanky[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Revizuirea codului, Bune practici in programarea orientata obiect, Refactorizare, Asigurarea calitatii sistemelor soft</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Sulyok Csaba" alt="Sulyok Csaba" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Sulyok-Csaba.jpg"/></div>
<div style="display: inline-block; width: 490px;">
SULYOK Csaba, <em>Doctorand</em><br/>
E-mail: sulyok.csaba[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Software Engineering, Procesare digitala a semnalelor, Instruire automata, Build Automation</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Szederjesi Arnold" alt="Szederjesi Arnold" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Szederjesi-Arnold-100x133.jpg"/></div>
<div style="display: inline-block; width: 490px;">
SZEDERJESI Arnold, <em>Doctorand</em><br/>
E-mail: arnold[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Intelligent Data Analysis, Inteligenta artificiala, Sisteme distribuite, Tehnologii</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Adrian Telcian" alt="Adrian Telcian" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Adrian-Telcian.jpg"/></div>
<div style="display: inline-block; width: 490px;">
TELCIAN Adrian, <em>Doctorand</em><br/>
E-mail: adriant[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Analiza conceptuala formala, Baze de date</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Mihai Teletin" alt="Mihai Teletin" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Mihai-Teletin.jpg"/></div>
<div style="display: inline-block; width: 490px;">
TELETIN Mihai, <em>Doctorand</em><br/>
E-mail: mihai.teletin[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Instruire automata, Deep Learning, Computer Vision</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="" alt="" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/missing-male-133x100.jpg"/></div>
<div style="display: inline-block; width: 490px;">
TICLE Daniel, <em>Doctorand</em><br/>
E-mail: daniel[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes:</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-15811" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Raul-Tosa.jpg" alt="Raul Tosa" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">TOŞA Raul, <em>Doctorand</em><br/>
E-mail: raul[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~raul" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~raul</a><br/>
Domenii de interes: Tehnologii de virtualizare hardware, Solutii de securitate, Vulnerability research, Penetration testing</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-16002" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Paul-Tirban.jpg" alt="Paul Tirban" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">ŢIRBAN Paul, <em>Doctorand</em><br/>
E-mail: tirban[at]cs.ubbcluj.ro<br/>
Web: <a href="https://web.archive.org/web/20190715184034/http://www.cs.ubbcluj.ro/~tirban" target="_blank" rel="noopener noreferrer">http://www.cs.ubbcluj.ro/~tirban</a><br/>
Domenii de interes: Cloud Computing, Software Engineering, Calitatea sistemelor soft</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Gelu Vac" alt="Gelu Vac" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Gelu-Vac.jpg"/></div>
<div style="display: inline-block; width: 490px;">
VAC Gelu, <em>Doctorand</em><br/>
E-mail: gelu.vac[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes:</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Zsigmond Imre" alt="Zsigmond Imre" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Zsigmond-Imre.jpg"/></div>
<div style="display: inline-block; width: 490px;">
ZSIGMOND Imre, <em>Doctorand</em><br/>
E-mail: imre[at]cs.ubbcluj.ro<br/>
Web:<br/>
Domenii de interes: Gamification</div>
</div>
<h2>Personal didactic auxiliar</h2>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-9191" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Balea-Gavrila.jpg" alt="Balea Gavrila" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">BALEA Gavrila, <em>Inginer de sistem</em><br/>
E-mail: gb[at].cs.ubbcluj.ro<br/>
Adresa: Campus 305, Tel: 5815, 5757</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-410" title="" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/missing-male-133x100.jpg" alt="" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">BALEA Felicia, <em>Tehnician</em><br/>
E-mail:<br/>
Adresa: Campus 331, Tel: 5815</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-410" title="" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/missing-male-133x100.jpg" alt="" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">CENAN Ioana, <em>Tehnician</em><br/>
E-mail: ioana.cenan[at].cs.ubbcluj.ro<br/>
Adresa: Campus 331, Tel: 5815</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Ioana Chiorean" alt="Ioana Chiorean" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Ioana-Chiorean.jpg"/></div>
<div style="display: inline-block; width: 490px;">
CHIOREAN Ioana, <em>Referent</em><br/>
E-mail: ioanachiorean[at]cs.ubbcluj.ro<br/>
Adresa: Campus 305, Tel: 5815, 5757</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full" style="width: 100px; height: 133px" title="Chiorean Marius" alt="Chiorean Marius" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Chiorean-Marius.jpg"/></div>
<div style="display: inline-block; width: 490px;">
CHIOREAN Marius, <em>Inginer de sistem</em><br/>
E-mail: marius[at]cs.ubbcluj.ro<br/>
Adresa: Campus 305, Tel: 5815, 5757</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-22618" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Colt-Alexandrina-Ramona.jpg" alt="Colt Alexandrina-Ramona" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">COLT Alexandrina-Ramona, <em>Secretara</em><br/>
E-mail: colt_alexandrina[at]cs.ubbcluj.ro<br/>
Adresa: Cladirea Centrala 122, Tel: 5254</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-410" title="" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/missing-male-133x100.jpg" alt="" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">GANSCA Gheorghe, <em>Tehnician</em><br/>
E-mail:<br/>
Adresa: Campus 331, Tel: 5815</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-17409" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Pasca-Gavril-133x100.jpg" alt="Pasca Gavril" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">PASCA Gavril, <em>Tehnician</em><br/>
E-mail: pasca[at]cs.ubbcluj.ro<br/>
Adresa: Campus 331, Tel: 5815</div>
</div>
<div style="border-bottom: 1px dashed black; margin-bottom: 12px; padding-bottom: 12px;">
<div style="width: 128px; display: inline-block; text-align: center;"><img class="alignnone size-full wp-image-8160" src="https://web.archive.org/web/20190715184034im_/http://www.cs.ubbcluj.ro/wp-content/uploads/Szasz-Paul.jpg" alt="Szasz Paul" width="100" height="133"/></div>
<div style="display: inline-block; width: 490px;">SZASZ Paul, <em>Tehnician</em><br/>
E-mail: paul[at]cs.ubbcluj.ro<br/>
Adresa: Campus 331, Tel: 5815, 5757</div>
</div>""";
    //1.preluare json [content]->[rendered]
    // var url =
    //     'http://www.cs.ubbcluj.ro/wp-json/wp/v2/pages/?slug=departamentul-de-informatica/';
    var url =
        'https://raw.githubusercontent.com/Iliescu-Dorin/CS-UBB/master/cincisprezece.txt';
    // var res = await http.get(url);
    var profesorsPageInformatica = await http.get(url);
    // var resBody = json.decode(res.body);
    // List profesorsPageInformatica = resBody;

    // var url2 =
    //     'http://www.cs.ubbcluj.ro/wp-json/wp/v2/pages/?slug=departamentul-de-matematica/';
    var url2 =
        'https://raw.githubusercontent.com/Iliescu-Dorin/CS-UBB/master/treiiulie';
    var profesorsPageMatematica = await http.get(url);
    // var res2 = await http.get(url2);
    // var resBody2 = json.decode(res2.body);
    // List profesorsPageMatematica = resBody2;
    int code = profesorsPageInformatica.statusCode;
    // int code = res.statusCode;
    if (code == 200) {
      setState(
        () {
          profesoriList.clear();
          loadingPerosane = false;

          //Preluat prin REST API doar continutul de pe site (in format HTML) cu profesorii
          String stringProfesorsInformatica = profesorsPageInformatica.body;
          // print(stringProfesors);
          // String stringProfesorsInformatica =
          //     profesorsPageInformatica[0]["content"]["rendered"];
          String stringProfesorsMatematica = profesorsPageMatematica.body;
          // String stringProfesorsMatematica = profesorsPageMatematica[0]["content"]["rendered"];
          String stringProfesors =
              stringProfesorsInformatica + stringProfesorsMatematica;
          //2.sparge continutul in substring-uri HTML cu fiecare profesor
          new File('assets/TESTMYhtmlFILES/iNFO/cincisprezece.txt')
              .readAsString()
              .then((String contents) {
            String stringProfesorsInformatica = contents;
          });

          String patttern =
              r"""(?=<img)(.*?)((.|\n)*?(Domenii de interes:|Adresa:|<\/div><\/div>|institute-for-enterprise-systems))(.*?)(((?=<\/div>)*)<\/div>|<br \/><\/div><\/div>)""";
          RegExp exp = new RegExp(patttern);
          Iterable<Match> matches = exp.allMatches(profiInfo + " " + profiMate);
          // for (Match match in matches) {
          //   print("AAAAAAAAAAAAAAAAA ${match.group(0)}\n");
          // }
          if (matches == null) print("No match");
          var index = 0;
          matches.forEach((m) => {profIdentityJsonToHtml.add(m.group(0))});

          //3.adauga toate proprietatile profesorului intr-o lista de profesori

          profIdentityJsonToHtml.forEach((p) {
            index++;
            dom.Document node = parse(p, generateSpans: true);
            SuperHero prof = new SuperHero();

            RegExp exp1 = new RegExp(r"""src=\"([^\"]+)"""); //extrage poza
            final matches1 = exp1.firstMatch(node.children.first.innerHtml);
            if (matches1.group(1) !=
                "http://www.cs.ubbcluj.ro/wp-content/uploads/Oliver-Oswald.jpg") {
              //ramane asa pana Oswald este modificat
              prof.photo = matches1.group(1);
            } else {
              prof.photo =
                  "http://www.cs.ubbcluj.ro/wp-content/uploads/Oliver-Skroch.jpg";
            }

            RegExp exp2 = new RegExp(r"(?<=\n)(.*)(?=\n|)"); //extrage detaliile
            Iterable<Match> matches2 =
                exp2.allMatches(node.children.first.text);
            if (index == 14) {
              print(index);
            }
            matches2.forEach((f) {
              if (f.group(1).contains('E-mail')) {
                prof.email = f.group(1).replaceFirst("[at]", "@");
              } else if (f.group(1).contains('Web')) {
                prof.web = f.group(1);
              } else if (f.group(1).contains('Adresa')) {
                prof.adress = f.group(1);
              } else if (f.group(1).contains('Domenii')) {
                prof.domainsOfInterest = f.group(1);
              } else {
                if (f.group(1).contains(',')) {
                  prof.name = f.group(1).substring(0, f.group(1).indexOf(','));
                  prof.tip = f.group(1).substring(f.group(1).indexOf(',') + 2);
                  // } else {
                  //   prof.name = f.group(1);
                  //   prof.tip = "";
                }
              }
            });
            profesoriList.add(prof);
          });
          return "Success";
        },
      );
    } else {
      setState(() {
        loadingPerosane = false;
      });
      return "Something went wrong";
    }
    profesoriList.forEach((pList) {
      program.forEach((oList) {
        if (!yourProfesors.contains(pList)) {
          // String prof = mat.group(1) != null ? mat.group(1) : "";//Dr. BARTELT Christian, Profesor Universitar Asociat Invitat "Institut für Enterprise Systems", Universität Mannheim
          if (pList.name.replaceAll(r'-', ' ') ==
                  "Dr. " + oList.cadrulDidactic ||
              pList.name.replaceAll(r'-', ' ') == oList.cadrulDidactic)
            yourProfesors.add(pList);
        }
      });
    });
  }

  @override
  void initState() {
    this.checkTheme();
    super.initState();
    this.getOrar();
    this.getPosts();
    this.getProfesors();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: theme == "dark" ? dark : light,
      home: SplashScreen.navigate(
        name: theme == "dark"
            ? 'assets/Student UBB-black.flr'
            : 'assets/Student UBB-white.flr',
        next: new ZoomScaffold(
          menuScreen: MenuScreen(),
          contentScreen: Layout(
              contentBuilder: (cc) => Container(
                    color: Theme.of(context).backgroundColor,
                    child: Container(
                      color: Theme.of(context).backgroundColor,
                    ),
                  )),
        ),
        until: () => Future.delayed(Duration(seconds: 5)),
        startAnimation: 'Intro',
        backgroundColor: theme == "dark" ? Colors.black : Colors.white,
      ),
    );

    // MaterialApp(
    //   home: new ZoomScaffold(
    //     menuScreen: MenuScreen(),
    //     contentScreen: Layout(
    //         contentBuilder: (cc) => Container(
    //               color: Theme.of(context).backgroundColor,
    //               child: Container(
    //                 color: Theme.of(context).backgroundColor,
    //               ),
    //             )),
    //   ),
    //   theme: theme == "dark" ? dark : light,
    // );
  }
}
