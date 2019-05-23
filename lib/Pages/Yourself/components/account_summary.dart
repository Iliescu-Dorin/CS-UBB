import 'package:flutter/material.dart';
import '../entities/account.dart';
import '../utils/assets.dart';

class CardView extends StatefulWidget {
  CardView({
    Key key,
    this.expand = false,
    this.onClick,
    this.account,
    this.width,
  }) : super(key: key);

  final bool expand;
  final Function onClick;
  final Account account;
  final double width;

  @override
  _CardViewState createState() => _CardViewState();
}

class _CardViewState extends State<CardView> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
  }

  Future<void> expand() async {
    try {
      await _controller.forward().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  Future<void> collapse() async {
    try {
      await _controller.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.expand) {
      expand();
    } else
      collapse();

    Brightness brightness =
        ThemeData.estimateBrightnessForColor(widget.account.color);
    Color textColor =
        brightness == Brightness.light ? Colors.black : Colors.white;

    return GestureDetector(
      onTap: () {
        widget.onClick();
      },
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 0),
        width: widget.width,
        child: Card(
          elevation: 6,
          color: widget.account.color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: StaggerAnimation(
            controller: _controller.view,
            child: Container(
              padding: EdgeInsets.all(20),
              width: double.maxFinite,
              child: Stack(
                children: <Widget>[
                  Column(
                    children: buildViews(context, textColor),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      color: widget.account.color,
                      child: Text(
                        widget.account.getAmountInString(),
                        style: TextStyle(color: textColor, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildViews(BuildContext context, Color textColor) {
    List list = <Widget>[
      Text(
        widget.account.name,
        style: TextStyle(color: textColor, fontSize: 18),
      ),
      Container(
        height: 4,
      ),
    ];

    if (widget.account.months != null) {
      list.add(
        Container(
          alignment: Alignment.topLeft,
          height: 20,
          child: Row(
            children: <Widget>[
              Image(
                image: Assets.image("date.png"),
              ),
              Text(
                " ${widget.account.months} months",
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (widget.account.cardNumber != null) {
      list.add(
        Container(
          alignment: Alignment.topLeft,
          height: 20,
          child: Row(
            children: <Widget>[
              Image(
                image: Assets.image("mastercard.png"),
              ),
              Text(
                " *${widget.account.getLastCardNumber()}",
                style: TextStyle(
                  color: textColor.withOpacity(0.5),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (widget.expand && widget.account.validThru != null) {
      list.add(Container(
        margin: EdgeInsets.only(top: 15),
        child: Column(
          children: <Widget>[
            Text(
              "Valid Thru".toUpperCase(),
              style: TextStyle(
                color: textColor.withOpacity(0.5),
                fontSize: 10,
              ),
            ),
            Text(
              widget.account.validThru,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
              ),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ));
    }
    return list;
  }
}

class StaggerAnimation extends StatelessWidget {
  final Widget child;

  StaggerAnimation({Key key, this.controller, this.child})
      : opacity = Tween<double>(
          begin: 129.0,
          end: 220.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              1,
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
    return Container(
      height: opacity.value,
      alignment: Alignment.bottomCenter,
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
