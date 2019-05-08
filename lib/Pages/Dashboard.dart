import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<List<double>> charts = [
    [
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4
    ],
    [
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4,
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4,
    ],
    [
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4,
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4,
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4
    ]
  ];

  // static final List<String> chartDropdownItems = [
  //   'Last 7 days',
  //   'Last month',
  //   'Last year'
  // ];
  // String actualDropdown = chartDropdownItems[0];
  // int actualChart = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StaggeredGridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      children: <Widget>[
        _buildTile(
          Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CalendarCarousel(
                    firstDayOfWeek: 1,
                    weekendTextStyle: TextStyle(
                      color: Colors.red,
                    ),
                    thisMonthDayBorderColor: Colors.grey,
                    weekFormat: false,
                    height: 320.0,
                    // width: 60.0,
                    daysHaveCircularBorder: false,

                    /// null for not rendering any border, true for circular border, false for rectangular border
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: <Widget>[
                  //     Column(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: <Widget>[
                  //         Text('Revenue',
                  //             style: TextStyle(color: Colors.green)),
                  //         Text('\$16K',
                  //             style: TextStyle(
                  //                 color: Colors.black,
                  //                 fontWeight: FontWeight.w700,
                  //                 fontSize: 34.0)),
                  //       ],
                  //     ),
                  //     DropdownButton(
                  //         isDense: true,
                  //         value: actualDropdown,
                  //         onChanged: (String value) => setState(() {
                  //               actualDropdown = value;
                  //               actualChart = chartDropdownItems
                  //                   .indexOf(value); // Refresh the chart
                  //             }),
                  //         items: chartDropdownItems.map((String title) {
                  //           return DropdownMenuItem(
                  //             value: title,
                  //             child: Text(title,
                  //                 style: TextStyle(
                  //                     color: Colors.blue,
                  //                     fontWeight: FontWeight.w400,
                  //                     fontSize: 14.0)),
                  //           );
                  //         }).toList())
                  //   ],
                  // ),
                  // Padding(padding: EdgeInsets.only(bottom: 4.0)),
                  // Sparkline(
                  //   data: charts[actualChart],
                  //   lineWidth: 5.0,
                  //   lineColor: Colors.greenAccent,
                  // )
                ],
              )),
        ),
        _buildTile(
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Material(
                          color: Colors.teal,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.book,
                                color: Colors.white, size: 60.0),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                    ),
                    Text(' Biblioteca',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 24.0)),
                    Text('      Lucian Blaga',
                        style: TextStyle(color: Colors.black45)),
                  ]),
            ),
            onTap: () => launch("https://www.bcucluj.ro/")),
        _buildTile(
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircularPercentIndicator(
                    radius: 90.0,
                    lineWidth: 10.0,
                    percent: 0.7,
                    center: new Text("70%",
                        style: TextStyle(color: Colors.black45)),
                    footer: new Text('Semestru',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 24.0)),
                    progressColor: Colors.green,
                  ),
                ]),
          ),
        ),
        _buildTile(
            Padding(
              padding: const EdgeInsets.all(24.0),
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
              padding: const EdgeInsets.all(24.0),
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
                "https://www.ubbcluj.ro/ro/studenti/burse/regulament_burse")
            )
      ],
      staggeredTiles: [
        StaggeredTile.extent(2, 350.0),
        StaggeredTile.extent(1, 190.0),
        StaggeredTile.extent(1, 190.0),
        StaggeredTile.extent(2, 110.0),
        StaggeredTile.extent(2, 110.0),
      ],
    ));
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
                    print('Not set yet');
                  },
            child: child));
  }
}
