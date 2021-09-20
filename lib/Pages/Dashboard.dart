import 'package:UBB/Pages/Setari/widget/superhero.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Setari/screens/Persoane.dart';
import 'Yourself/components/bottom_sheet.dart';
import 'Yourself/entities/account.dart';
import 'Yourself/views/favourite_list.dart';
import 'Yourself/views/transaction.dart';
import 'Yourself/views/transition_bottom_sheet.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

class _MainPageState extends State<MainPage> {
  Account _selectedAccount;
  @override
  void initState() {
    super.initState();
  }

  void showFavouriteInfo(BuildContext context, SuperHero favourite) {
    showModalBottomSheetApp(
      context: context,
      builder: (context) => TransitionBottomSheetView(favourite: favourite),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: StaggeredGridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: <Widget>[
          _buildTile(
            Padding(
              padding:
                  const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0),
              child: GestureDetector(
                onLongPress: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new Persoane()));
                },
                child: Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: <Widget>[
                    Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Colors.transparent,
                        scaffoldBackgroundColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        dialogBackgroundColor: Colors.transparent,
                        colorScheme: Theme.of(context).colorScheme.copyWith(
                            background: Colors.transparent,
                            surface: Colors.transparent),
                      ),
                      child: Builder(
                        builder: (context) => FavouriteListView(
                          onSelect: (account) =>
                              showFavouriteInfo(context, account),
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        "Profesori",
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildTile(
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Material(
                        color: Colors.teal,
                        shape: CircleBorder(),
                        child: Container(
                          child: Icon(
                            EvaIcons.bookOutline,
                            color: Colors.white,
                            size: 45.0,
                          ),
                          width: 60,
                          height: 60,
                        ),
                      ),
                      Text(' Biblioteca',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 24.0)),
                      Text('Lucian Blaga',
                          style: TextStyle(color: Colors.black45)),
                    ]),
              ),
              onTap: () => launch("https://www.bcucluj.ro/")),
          FlipCard(
            direction: FlipDirection.HORIZONTAL, // default
            key: cardKey,
            front: _buildTileF(
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      CircularPercentIndicator(
                        radius: 95.0,
                        lineWidth: 10.0,
                        percent: _procent(),
                        center: new Text('${(_procent() * 100).toInt()}%',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 24.0)),
                        progressColor: Colors.green,
                      ),
                    ]),
              ),
            ),
            back: _buildTileF(
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      CircularPercentIndicator(
                        radius: 95.0,
                        lineWidth: 10.0,
                        percent: _procent(),
                        center: new Text('${_zile()}\nZile',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 24.0)),
                        progressColor: Colors.green,
                      ),
                    ]),
              ),
            ),
          ),
          _buildTile(
            Container(
              child: TransactionsView(),
            ),
          ),
          _buildTile(
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Burse',
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('Erasmus',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 34.0))
                        ],
                      ),
                      Material(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(24.0),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.timeline,
                                color: Colors.white, size: 30.0),
                          )))
                    ]),
              ),
              onTap: () => launch("http://www.cs.ubbcluj.ro/~erasmus/")),
          _buildTile(
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Burse',
                              style: TextStyle(color: Colors.redAccent)),
                          Text('Universitare',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 34.0))
                        ],
                      ),
                      Material(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(24.0),
                          child: Center(
                              child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Icon(Icons.store,
                                color: Colors.white, size: 30.0),
                          )))
                    ]),
              ),
              onTap: () => launch(
                  "https://www.ubbcluj.ro/ro/studenti/burse/regulament_burse")),
        ],
        staggeredTiles: [
          StaggeredTile.extent(2, 100.0),
          StaggeredTile.extent(1, 150.0),
          StaggeredTile.extent(1, 150.0),
          StaggeredTile.extent(2, 300.0),
          StaggeredTile.extent(2, 80.0),
          StaggeredTile.extent(2, 80.0),
        ],
      ),
    );
  }

  Widget _buildTileF(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        // shadowColor: Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: () => cardKey.currentState.toggleCard(),
            child: child));
  }
}

Widget _buildTile(Widget child, {Function() onTap}) {
  return Material(
      elevation: 14.0,
      borderRadius: BorderRadius.circular(12.0),
      // shadowColor: Color(0x802196F3),
      child: InkWell(
          // Do onTap() if it isn't null, otherwise do print()
          onTap: onTap != null
              ? () => onTap()
              : () {
                  print('Not set yet');
                },
          child: child));
}

//!!! De testat
double _procent() {
  int zileRamase;
  int totalZile;
  var now = new DateTime.now();
  var anNou = DateTime(now.year + 1, 1, 1);
  var anCurent = DateTime(now.year, 1, 1);
  var inceputSem1 = DateTime(now.year, 2, 23);
  var inceputSem1AftAnNou = DateTime(now.year - 1, 10, 1);
  var sfarsitSem1BefAnNou = DateTime(now.year + 1, 2, 23);
  var sfarsitSem1AftAnNou = DateTime(now.year, 2, 23);
  var inceputSem2AnulNou = DateTime(now.year, 3, 1);
  var sfarsitSem2AnulNou = DateTime(now.year, 7, 12);

  if (now.month >= 10 && now.month <= 12) {
    zileRamase = int.parse(anNou.difference(now).inDays.toString()) +
        int.parse(sfarsitSem1BefAnNou.difference(anNou).inDays.toString());
    totalZile = int.parse(
        sfarsitSem1BefAnNou.difference(inceputSem1).inDays.toString());
  } else if (now.month >= 1 && now.month <= 2) {
    zileRamase =
        int.parse(sfarsitSem1AftAnNou.difference(anCurent).inDays.toString());
    totalZile = int.parse(
        sfarsitSem1AftAnNou.difference(inceputSem1AftAnNou).inDays.toString());
  } else if (now.month >= 3 && now.month <= 7) {
    zileRamase = int.parse(
        sfarsitSem2AnulNou.difference(inceputSem2AnulNou).inDays.toString());
    totalZile = int.parse(
        sfarsitSem2AnulNou.difference(inceputSem2AnulNou).inDays.toString());
  } else {
    return 0;
  }

  return zileRamase / totalZile;
}

int _zile() {
  int zileRamase;

  var now = new DateTime.now();
  var anNou = DateTime(now.year + 1, 1, 1);
  var anCurent = DateTime(now.year, 1, 1);

  var sfarsitSem1BefAnNou = DateTime(now.year + 1, 2, 23); // 23.02.an+1
  var sfarsitSem1AftAnNou = DateTime(now.year, 2, 23); //23.02
  var inceputSem2AnulNou = DateTime(now.year, 3, 1);
  var sfarsitSem2AnulNou = DateTime(now.year, 7, 12);

  if (now.month >= 10 && now.month <= 12) {
    zileRamase = int.parse(anNou.difference(now).inDays.toString()) +
        int.parse(sfarsitSem1BefAnNou.difference(anNou).inDays.toString());
  } else if (now.month >= 1 && now.month <= 2) {
    zileRamase =
        int.parse(sfarsitSem1AftAnNou.difference(anCurent).inDays.toString());
  } else if (now.month >= 3 && now.month <= 7) {
    zileRamase = int.parse(
        sfarsitSem2AnulNou.difference(inceputSem2AnulNou).inDays.toString());
  } else {
    zileRamase = 0;
  }

  return zileRamase;
}

///inceput de semestru I:       1.10.AN   (AN/1)
///an nou:                      01.01.AN  (AN/1)
///sfarsit de semestru I:	      23.02.AN+1  (AN-1/1)
///inceput de semestru II:      24.02 AN  (AN-1/2)
///sfarsit de semsestru II:     12.07.AN  (AN-1/2)
