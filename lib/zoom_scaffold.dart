import 'package:UBB/Pages/Setari/screens/settings.dart';
import 'package:UBB/Pages/Setari/widget/superhero.dart';
import 'package:UBB/Pages/Stiri/MyHomePage.dart';
import 'package:connectivity/connectivity.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './Pages/Dashboard.dart';
import 'package:rounded_floating_app_bar/rounded_floating_app_bar.dart';
import "./Pages/Login/login_page.dart";
import './Pages/Info/Info.dart';
import 'Pages/Orar/orar.dart';
import 'Pages/Yourself/components/bottom_sheet.dart';
import 'Pages/Yourself/entities/account.dart';
import 'Pages/Yourself/entities/favourite.dart';
import 'Pages/Yourself/views/transition_bottom_sheet.dart';
import 'main.dart';

class ZoomScaffold extends StatefulWidget {
  final Widget menuScreen;
  final Layout contentScreen;

  ZoomScaffold({
    this.menuScreen,
    this.contentScreen,
  });

  @override
  _ZoomScaffoldState createState() => new _ZoomScaffoldState();
}

class _ZoomScaffoldState extends State<ZoomScaffold>
    with TickerProviderStateMixin {
  String name = "";

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString("name");
  }

  MenuController menuController;
  Curve scaleDownCurve = new Interval(0.0, 0.3, curve: Curves.easeOut);
  Curve scaleUpCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideOutCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideInCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);

  PageController pageController = new PageController(
    initialPage: 0,
    keepPage: true,
  );
  int bottomSelectedIndex = 0;
  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        MainPage(),
        MyHomePage(),
        Orar(),
        LoginPage(),
      ],
    );
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  @override
  void initState() {
    getSharedPrefs();
    super.initState();

    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
  }

  void showFavouriteInfo(BuildContext context, SuperHero favourite) {
    showModalBottomSheetApp(
      context: context,
      builder: (context) => TransitionBottomSheetView( favourite: favourite),
    );
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  createContentDisplay() {
    return zoomAndSlideContent(
      new Container(
        child: new Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: NestedScrollView(
            headerSliverBuilder: (context, isInnerBoxScroll) {
              return [
                RoundedFloatingAppBar(
                  leading: new IconButton(
                      icon: new Icon(
                        Icons.menu,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        menuController.toggle();
                      }),
                  actions: <Widget>[
                    GestureDetector(
                        onLongPress: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String prefTheme = prefs.getString("theme") == null
                              ? "light"
                              : prefs.getString("theme");
                          if (prefTheme == "light") {
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            preferences.setString("theme", "dark");
                            MyMainPage.restartApp(context);
                          } else if (prefTheme == "dark") {
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            preferences.setString("theme", "light");
                            MyMainPage.restartApp(context);
                          } else {
                            print("shit happened");
                          }
                        },
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new Settings()));
                          },
                          icon: Icon(
                            EvaIcons.settingsOutline,
                            color: Colors.grey,
                          ),
                        )),
                    // IconButton(
                    //   onPressed: () {
                    //     Navigator.push(
                    //         context,
                    //         new MaterialPageRoute(
                    //             builder: (context) => new Info()));
                    //   },
                    //   icon: Icon(
                    //     Icons.info,
                    //     color: Colors.grey,
                    //   ),
                    // )
                  ],
                  iconTheme: IconThemeData(
                    color: Colors.black,
                  ),
                  textTheme: TextTheme(
                    title: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  floating: false,
                  snap: false,
                  pinned: true,
                  title: Container(
                    alignment: AlignmentDirectional.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: name == ""
                          ? Text(
                              "Student UBB",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          : Text(
                              "$name",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                    ),
                  ),
                  // backgroundColor: Colors.grey,
                ),
              ];
            },
            body: OfflineBuilder(
              connectivityBuilder: (
                BuildContext context,
                ConnectivityResult connectivity,
                Widget child,
              ) {
                final bool connected = connectivity != ConnectivityResult.none;
                return Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    buildPageView(),
                    Positioned(
                      height: 18.0,
                      left: 0.0,
                      right: 0.0,
                      bottom: 0.0,
                      child: Container(
                        color: connected
                            ? Theme.of(context).accentColor
                            : Color(0xFFEE4400),
                        child: Center(
                          child: Text("${connected ? 'ONLINE' : 'OFFLINE'}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ],
                );
              },
              child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  ),
            ),
          ),
          bottomNavigationBar: CurvedNavigationBar(
            color: Theme.of(context).backgroundColor,
            buttonBackgroundColor: Theme.of(context).unselectedWidgetColor,
            index: bottomSelectedIndex,
            height: 60.0,
            backgroundColor: Theme.of(context).accentColor,
            items: <Widget>[
              Icon(
                Icons.home,
                size: 30,
              ),
              Icon(Icons.web, size: 30),
              Icon(Icons.schedule, size: 30),
              Icon(Icons.mail, size: 30),
            ],
            onTap: (index) {
              bottomTapped(index);
            },
          ),
        ),
      ),
    );
  }

  zoomAndSlideContent(Widget content) {
    var slidePercent, scalePercent;
    switch (menuController.state) {
      case MenuState.closed:
        slidePercent = 0.0;
        scalePercent = 0.0;
        break;
      case MenuState.open:
        slidePercent = 1.0;
        scalePercent = 1.0;
        break;
      case MenuState.opening:
        slidePercent = slideOutCurve.transform(menuController.percentOpen);
        scalePercent = scaleDownCurve.transform(menuController.percentOpen);
        break;
      case MenuState.closing:
        slidePercent = slideInCurve.transform(menuController.percentOpen);
        scalePercent = scaleUpCurve.transform(menuController.percentOpen);
        break;
    }

    final slideAmount = 275.0 * slidePercent;
    final contentScale = 1.0 - (0.2 * scalePercent);
    final cornerRadius = 16.0 * menuController.percentOpen;

    return new Transform(
      transform: new Matrix4.translationValues(slideAmount, 0.0, 0.0)
        ..scale(contentScale, contentScale),
      alignment: Alignment.centerLeft,
      child: new Container(
        decoration: new BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: Colors.black12,
              offset: const Offset(0.0, 5.0),
              blurRadius: 15.0,
              spreadRadius: 10.0,
            ),
          ],
        ),
        child: new ClipRRect(
            borderRadius: new BorderRadius.circular(cornerRadius),
            child: content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Scaffold(
            body: widget.menuScreen,
          ),
        ),
        createContentDisplay()
      ],
    );
  }
}

class ZoomScaffoldMenuController extends StatefulWidget {
  final ZoomScaffoldBuilder builder;

  ZoomScaffoldMenuController({
    this.builder,
  });

  @override
  ZoomScaffoldMenuControllerState createState() {
    return new ZoomScaffoldMenuControllerState();
  }
}

class ZoomScaffoldMenuControllerState
    extends State<ZoomScaffoldMenuController> {
  MenuController menuController;

  @override
  void initState() {
    super.initState();

    menuController = getMenuController(context);
    menuController.addListener(_onMenuControllerChange);
  }

  @override
  void dispose() {
    menuController.removeListener(_onMenuControllerChange);
    super.dispose();
  }

  getMenuController(BuildContext context) {
    final scaffoldState =
        context.ancestorStateOfType(new TypeMatcher<_ZoomScaffoldState>())
            as _ZoomScaffoldState;
    return scaffoldState.menuController;
  }

  _onMenuControllerChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, getMenuController(context));
  }
}

typedef Widget ZoomScaffoldBuilder(
    BuildContext context, MenuController menuController);

class Layout {
  final WidgetBuilder contentBuilder;

  Layout({
    this.contentBuilder,
  });
}

class MenuController extends ChangeNotifier {
  final TickerProvider vsync;
  final AnimationController _animationController;
  MenuState state = MenuState.closed;

  MenuController({
    this.vsync,
  }) : _animationController = new AnimationController(vsync: vsync) {
    _animationController
      ..duration = const Duration(milliseconds: 250)
      ..addListener(() {
        notifyListeners();
      })
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            state = MenuState.opening;
            break;
          case AnimationStatus.reverse:
            state = MenuState.closing;
            break;
          case AnimationStatus.completed:
            state = MenuState.open;
            break;
          case AnimationStatus.dismissed:
            state = MenuState.closed;
            break;
        }
        notifyListeners();
      });
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  get percentOpen {
    return _animationController.value;
  }

  open() {
    _animationController.forward();
  }

  close() {
    _animationController.reverse();
  }

  toggle() {
    if (state == MenuState.open) {
      close();
    } else if (state == MenuState.closed) {
      open();
    }
  }
}

enum MenuState {
  closed,
  opening,
  open,
  closing,
}
