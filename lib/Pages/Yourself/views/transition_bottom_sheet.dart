import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../entities/account.dart';
import '../entities/favourite.dart';
import '../utils/assets.dart';

class TransitionBottomSheetView extends StatefulWidget {
  const TransitionBottomSheetView(
      {Key key, @required this.account, @required this.favourite})
      : super(key: key);

  final Account account;
  final Favourite favourite;

  @override
  State<StatefulWidget> createState() {
    return _TransitionBottomSheetViewState();
  }
}

class _TransitionBottomSheetViewState extends State<TransitionBottomSheetView>
    with TickerProviderStateMixin {
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
    return Column(
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
                      image: Assets.image(widget.favourite.image),
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
                    child: Text("From",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: buildAccountSummary(context, widget.account, true),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
          createDivider(
            color: dividerColor,
            height: 41,
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
                  child: Container(
                    child: Text("To",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: buildAccountSummary(
                      context, widget.favourite.account, false),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
          createDivider(
            color: dividerColor,
            height: 41,
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
                  child: Container(
                    child: Text("Message",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400)),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: _border,
                    enabledBorder: _border,
                    focusedBorder: _border,
                    hintText: "Hi! Leave a message",
                  ),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
          createDivider(
            color: dividerColor,
            height: 41,
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
                  child: Container(
                    alignment: Alignment.center,
                    child: Text("Amount",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400)),
                  ),
                ),
                Container(
                  width: 130,
                  child: TextFormField(
                    textAlign: TextAlign.right,
                    controller: _amountController,
                    style: amountTextStyle,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: _border,
                      enabledBorder: _border,
                      focusedBorder: _border,
                      hintStyle: amountTextStyle,
                      prefixStyle: amountTextStyle,
                      suffixStyle: amountTextStyle.copyWith(
                          color: Colors.black.withOpacity(0.5)),
                      suffixText: ".00",
                      prefixText: "\$",
                    ),
                  ),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
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
                    "Transaction complete",
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
                          Container(
                            child: buildAccountSummary(
                                context, widget.account, false),
                          ),
                          Container(
                            height: 44,
                            width: 20,
                          ),
                          Container(
                            child: buildAccountSummary(
                                context, widget.favourite.account, false),
                          ),
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
                      ))
                    ],
                  ),
                  margin: EdgeInsets.only(top: 43),
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
              Opacity(
                opacity: 0.5,
                child: Container(
                  child: Text("Amount",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 4),
                child: Text.rich(
                  TextSpan(text: "\$${_amountController.text}", children: [
                    TextSpan(
                        text: ".00",
                        style: TextStyle(color: Colors.black.withOpacity(0.5)))
                  ]),
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                ),
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
        ],
      ),
    );
  }

  buildAccountSummary(
      BuildContext context, Account account, bool displayAmount) {
    List<Widget> widgets = [
      Card(
        color: account.color,
        child: Container(
          padding: EdgeInsets.all(7),
          width: 34,
          child: Image(
            image: Assets.image("mastercard.png"),
            height: 12,
            width: 18,
            fit: BoxFit.scaleDown,
          ),
          height: 26,
        ),
      ),
      Container(
        margin: EdgeInsets.only(left: 10),
        child: Text(
          "${account.name} *${account.getLastCardNumber()}",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
      ),
    ];
    if (displayAmount) {
      widgets.addAll([
        Expanded(
          child: Container(),
          flex: 1,
        ),
        Container(
          child: Text(
            displayAmount ? "${account.getAmountInString()}" : "",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
        ),
      ]);
    }
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

  createAction(BuildContext context) {
    List<Widget> actions = <Widget>[];

    if (_step > 1) {
      actions.addAll([
        Expanded(
          child: FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 59,
              alignment: Alignment.center,
              child: Text(
                "Template",
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
              Navigator.of(context).pop();
            },
            child: Container(
              height: 59,
              alignment: Alignment.center,
              child: Text(
                "Repeat",
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
                "Pay",
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
