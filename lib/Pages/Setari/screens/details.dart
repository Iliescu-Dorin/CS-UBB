import 'dart:ui';
import 'package:UBB/Pages/Setari/widget/superhero_avatar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Details extends StatefulWidget {
  final String name;
  final String tip;
  final String photo;
  final String email;
  final String web;
  final String adress;
  final String domainsOfInterest;

  const Details(
      {Key key,
      this.name,
      this.tip,
      this.photo,
      this.email,
      this.web,
      this.adress,
      this.domainsOfInterest})
      : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: SuperheroDetails(
        name: widget.name,
        tip: widget.tip,
        web: widget.web,
        adress: widget.adress,
        domainsOfInterest: widget.domainsOfInterest,
        email: widget.email,
        photo: widget.photo,
      ),
    );
  }
}

class SuperheroDetails extends StatefulWidget {
  final String name;
  final String tip;
  final String photo;
  final String email;
  final String web;
  final String adress;
  final String domainsOfInterest;

  const SuperheroDetails(
      {Key key,
      this.name,
      this.tip,
      this.photo,
      this.email,
      this.web,
      this.adress,
      this.domainsOfInterest})
      : super(key: key);

  @override
  _SuperheroDetailsState createState() => _SuperheroDetailsState();
}

class _SuperheroDetailsState extends State<SuperheroDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            SuperheroAvatar(
              img: widget.photo,
              radius: 50.0,
            ),
            SizedBox(
              height: 25.0,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    widget.web.substring(16),
                    style: textTheme.subtitle.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  new Text(
                    '      |      ',
                    style: textTheme.subtitle.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  new Text(
                    widget.email.substring(8),
                    style: textTheme.subtitle.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                left: 16.0,
                right: 16.0,
              ),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // new DecoratedBox(
                  // decoration: new BoxDecoration(
                  //   border: new Border.all(color: Colors.white30),
                  //   borderRadius: new BorderRadius.circular(30.0),
                  // ),
                  // child:
                  RaisedButton(
                    color: Colors.blue,
                    onPressed: () {
                      launch(widget.web.substring(5));
                    },
                    child: Text('WEB'),
                    // backgroundColor: theme.accentColor,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  // ),
                  RaisedButton(
                    color: Colors.blue,
                    onPressed: () {},
                    child: Text('E-MAIL'),
                    // backgroundColor: theme.accentColor,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 35.0,
            ),
            Row(
              children: <Widget>[
                new Icon(
                  Icons.place,
                  color: Colors.blue,
                  size: 16.0,
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: new Text(
                    widget.adress,
                    style: textTheme.body1.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50.0,
            ),
            Text(
              widget.domainsOfInterest.substring(20),
              style: textTheme.body1.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 21,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 50.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                      onTap: () {}, child: _createPillButton("Sterge ")),
                ),
                Expanded(
                  child: GestureDetector(
                      onTap: () {}, child: _createPillButton("Adauga")),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _createPillButton(
    String text, {
    Color backgroundColor = Colors.transparent,
    Color textColor = Colors.white70,
  }) {
    return new ClipRRect(
      borderRadius: new BorderRadius.circular(180.0),
      child: new MaterialButton(
        minWidth: 140.0,
        color: backgroundColor,
        textColor: textColor,
        onPressed: () {},
        child: new Text(text),
      ),
    );
  }
}
