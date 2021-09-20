import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:UBB/Pages/Setari/widget/superhero.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/assets.dart';

class TransitionBottomSheetView extends StatefulWidget {
  const TransitionBottomSheetView({Key key, @required this.favourite})
      : super(key: key);

  final SuperHero favourite;

  @override
  State<StatefulWidget> createState() {
    return _TransitionBottomSheetViewState();
  }
}

class _TransitionBottomSheetViewState extends State<TransitionBottomSheetView>
    with TickerProviderStateMixin {
  String attachment;

  final _subjectController = TextEditingController(text: '');

  final _bodyController = TextEditingController(
    text: "",
  );
  // final _recipientController = TextEditingController(text: "");

  String email;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<String> getIt() async {
    email = widget.favourite.email;
    return email;
    // String get imagePath => imagePath;
  }

  Future<void> send() async {
    final Email email = Email(
      body: _bodyController.text,
      subject: _subjectController.text,
      recipients: [widget.favourite.email.substring(8)],
      attachmentPath: attachment,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    // if (!mounted) return;

    // _scaffoldKey.currentState.showSnackBar(SnackBar(
    // content: Text(platformResponse),
    // ));
  }

  int _step = 0;

  Timer timer;
  double percent = 0.0;

  Color dividerColor = Color.fromRGBO(238, 241, 244, 1);
  TextStyle amountTextStyle =
      TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w700);

  UnderlineInputBorder _border =
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent));

  AnimationController _controller;
  AnimationController _animationController;
  TextEditingController _amountController;

  @override
  void initState() {
    getSPEmail();
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _amountController = new TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    if (timer != null) {
      timer.cancel();
    }

    _controller.dispose();
    _animationController.dispose();
    _amountController.dispose();
  }

  Future<void> step2() async {
    try {
      await _controller.animateTo(0.5).orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  Future<void> step3() async {
    try {
      await _controller.forward().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  @override
  Widget build(BuildContext context) {
    // final Widget imagePath = Text(attachment ?? '');

    return Column(
      key: _scaffoldKey,
      children: [
        Expanded(
          child: Container(),
          flex: 1,
        ),
        StaggerAnimation(
          controller: _controller,
          child: Stack(
            children: [
              Positioned.fill(
                top: 32,
                left: 20,
                right: 20,
                bottom: 24,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(24))),
                        child: _step == 0
                            ? buildForm(context)
                            : buildLoadingView(context),
                      ),
                      flex: 1,
                    ),
                    Container(
                      height: 10,
                    ),
                    Card(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(24))),
                        child: Row(children: createAction(context))),
                  ],
                ),
              ),
              HideAnimation(
                controller: _controller,
                child: Container(
                  alignment: Alignment.topCenter,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image(
                      image: NetworkImage(widget.favourite.photo),
                      height: 64,
                      width: 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildForm(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 20, top: 32),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              right: 20,
              left: 20,
            ),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 10),
                  child: Text(widget.favourite.name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                ),
                Opacity(
                  opacity: 0.5,
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      "De La: ",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                TextField(
                  textAlign: TextAlign.center,
                  controller: _textControllerEmail,
                  readOnly: true,
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: buildAccountSummary(context, widget.favourite, true),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
          createDivider(
            color: dividerColor,
            height: 1,
          ),
          Container(
            padding: EdgeInsets.only(
              right: 20,
              left: 20,
            ),
            child: Column(
              children: <Widget>[
                Opacity(
                  opacity: 0.5,
                  child: TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      border: _border,
                      enabledBorder: _border,
                      focusedBorder: _border,
                      hintText:
                          widget.favourite.email.substring(8) + " (default)",
                    ),
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.only(top: 8),
                //   child: buildAccountSummary(
                //       context, widget.favourite.account, false),
                // ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
          createDivider(
            color: dividerColor,
            height: 1,
          ),
          Container(
            padding: EdgeInsets.only(
              right: 20,
              left: 20,
            ),
            child: Column(
              children: <Widget>[
                Opacity(
                  opacity: 0.5,
                  child: TextFormField(
                    controller: _subjectController,
                    decoration: InputDecoration(
                      border: _border,
                      enabledBorder: _border,
                      focusedBorder: _border,
                      hintText: "Titlu :",
                    ),
                  ),
                ),
                Divider(),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              right: 20,
              left: 20,
            ),
            child: TextFormField(
              controller: _bodyController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                border: _border,
                enabledBorder: _border,
                focusedBorder: _border,
                hintText: "Salut! Lasa un mesaj",
              ),
            ),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }

  buildLoadingView(BuildContext context) {
    if (timer != null) timer.cancel();
    timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        percent += 0.05;
      });
      if (percent >= 1) {
        setState(() {
          _step++;
        });
        step3();

        timer.cancel();
      }
    });
    return Container(
      width: double.maxFinite,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 17),
                  width: 60,
                  height: 60,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: Tween(
                            begin: Colors.grey.shade200,
                          ).animate(
                            CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(
                                0.0,
                                1,
                                curve: Curves.ease,
                              ),
                            ),
                          ),
                          value: 1,
                        ),
                      ),
                      Positioned.fill(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              Tween(begin: Colors.green, end: Colors.green)
                                  .animate(
                            CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(
                                0.0,
                                1,
                                curve: Curves.ease,
                              ),
                            ),
                          ),
                          value: percent,
                        ),
                      ),
                      Positioned.fill(
                        child: Opacity(
                          opacity: percent >= 1 ? 1.0 : 0.0,
                          child: Icon(
                            Icons.done,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    "E-mail Pregatit",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          TextField(
                            controller: _textControllerEmail,
                            readOnly: true,
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            child: buildAccountSummary(
                                context, widget.favourite, false),
                          ),
                          Container(
                            height: 44,
                            width: 20,
                          ),
                          // Container(
                          //   child: buildAccountSummary(
                          //       context, widget.favourite.account, false),
                          // ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                      ),
                      Positioned.fill(
                          child: Container(
                        margin: EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        child: Icon(
                          Icons.arrow_downward,
                          color: Color.fromRGBO(180, 189, 197, 1),
                        ),
                        alignment: Alignment.center,
                      )),
                    ],
                  ),
                  margin: EdgeInsets.only(top: 43),
                ),
                TextFormField(
                  readOnly: true,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: widget.favourite.email.substring(8),
                  ),
                ),
              ],
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ),
          createDivider(
            color: dividerColor,
            height: 41,
          ),
          Column(
            children: <Widget>[
              attachment == null
                  ? Text("Imagine: ")
                  : Text("Imagine: $attachment")
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
        ],
      ),
    );
  }

  String _name;
  //TODO: Aici modifici continutul Cardurilor(pentru email)
  TextEditingController _textControllerEmail;
  Future<Null> getSPEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _name = prefs.getString("name");
    setState(() {
      _textControllerEmail =
          new TextEditingController(text: _name + "@scs.ubbcluj.ro");
    });
  }

  buildAccountSummary(
      BuildContext context, SuperHero prof, bool displayAmount) {
    List<Widget> widgets = [
      Container(
        padding: EdgeInsets.all(7),
        width: 50,
        child: SizedBox.shrink(),
      ),
    ];
    return Row(
      children: widgets,
      mainAxisSize: MainAxisSize.min,
    );
  }

  createDivider({Color color, double height}) {
    double gap = (height - 1) / 2;
    return Container(
      color: color,
      height: 1,
      margin: EdgeInsets.only(top: gap, bottom: gap),
    );
  }

  void _openImagePicker() async {
    File pick = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      attachment = pick.path;
    });
  }

  createAction(BuildContext context) {
    //actiuni de dupa
    List<Widget> actions = <Widget>[];

    if (_step > 1) {
      actions.addAll([
        Expanded(
          child: FlatButton(
            onPressed: () {
              _openImagePicker();
            },
            child: Container(
              height: 59,
              alignment: Alignment.center,
              child: Text(
                "Imagine",
                style: TextStyle(fontSize: 20),
              ),
              width: MediaQuery.of(context).size.width,
            ),
          ),
          flex: 1,
        ),
        Container(
          width: 1,
          color: dividerColor,
          height: 59,
        ),
        Expanded(
          child: FlatButton(
            onPressed: () {
              send();
              Navigator.of(context).pop();
            },
            child: Container(
              height: 59,
              alignment: Alignment.center,
              child: Text(
                "Trimite",
                style: TextStyle(fontSize: 20),
              ),
              width: MediaQuery.of(context).size.width,
            ),
          ),
          flex: 1,
        ),
      ]);
    } else {
      actions.addAll([
        Expanded(
          child: FlatButton(
            onPressed: () {
              step2();
              setState(() {
                _step++;
              });
            },
            child: Container(
              height: 59,
              alignment: Alignment.center,
              child: Text(
                "Gata",
                style: TextStyle(fontSize: 20),
              ),
              width: MediaQuery.of(context).size.width,
            ),
          ),
          flex: 1,
        ),
      ]);
    }
    return actions;
  }
}

class StaggerAnimation extends StatelessWidget {
  final Widget child;

  StaggerAnimation({Key key, this.controller, this.child})
      : padding = Tween<double>(
          begin: 0.0,
          end: 42.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              0.5,
              curve: Curves.ease,
            ),
          ),
        ),
        offset = Tween<Offset>(
          begin: Offset(0, 0),
          end: Offset(0, 89),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              0.5,
              curve: Curves.ease,
            ),
          ),
        ),
        offset2 = Tween<Offset>(
          end: Offset(0, 0),
          begin: Offset(0, 89),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.5,
              1,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);

  final Animation<double> controller;
  final Animation<double> padding;
  final Animation<Offset> offset;
  final Animation<Offset> offset2;

  // This function is called each time the controller "ticks" a new frame.
  // When it runs, all of the animation's values will have been
  // updated to reflect the controller's current value.
  Widget _buildAnimation(BuildContext context, Widget c) {
    return Transform.translate(
      offset: padding.value == 42.0 ? offset2.value : offset.value,
      child: Container(
        padding: EdgeInsets.only(top: padding.value),
        height: 619,
        alignment: Alignment.bottomCenter,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}

class HideAnimation extends StatelessWidget {
  final Widget child;

  HideAnimation({Key key, this.controller, this.child})
      : opacity = Tween<double>(
          begin: 1,
          end: 0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              0.5,
              curve: Curves.ease,
            ),
          ),
        ),

        // ... Other tween definitions ...

        super(key: key);

  final Animation<double> controller;
  final Animation<double> opacity;

  // This function is called each time the controller "ticks" a new frame.
  // When it runs, all of the animation's values will have been
  // updated to reflect the controller's current value.
  Widget _buildAnimation(BuildContext context, Widget c) {
    return Opacity(
      opacity: opacity.value,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}
