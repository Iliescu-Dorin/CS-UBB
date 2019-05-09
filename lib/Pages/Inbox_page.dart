import 'dart:async';
import 'dart:convert' show utf8;
import "package:imap_client/imap_client.dart";
import 'package:flutter/material.dart';
import 'package:flutter_multi_carousel/carousel.dart';
import 'package:mobile_popup/mobile_popup.dart';
import 'package:shimmer/shimmer.dart';

class Imbox extends StatefulWidget {
  final String user;
  final String pass;
  Imbox({Key key, this.user, this.pass}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ImboxState();
  }
}

class _ImboxState extends State<Imbox> {
  ImapClient client = new ImapClient();

  List<String> subjects = [];
  List<String> dates = [];
  List<String> froms = [];
  List<String> tos = [];
  List<String> bodies = [];

  Future<String> getPosts() async {
    await client.connect("scs.ubbcluj.ro", 993, true);
    await client.authenticate(new ImapPlainAuth(widget.user, widget.pass));

    ImapFolder inbox = await client.getFolder("inbox");
    for (var i = inbox.mailCount; i > 0; i--) {
      var resSubj = await inbox
          .fetch(["BODY.PEEK[HEADER.FIELDS (SUBJECT)]"], messageIds: [i]);
      var subject = resSubj[i]["BODY[HEADER.FIELDS (SUBJECT)]"];

      var resDate = await inbox
          .fetch(["BODY.PEEK[HEADER.FIELDS (DATE)]"], messageIds: [i]);
      var date = resDate[i]["BODY[HEADER.FIELDS (DATE)]"];
      var resFrom = await inbox
          .fetch(["BODY.PEEK[HEADER.FIELDS (From)]"], messageIds: [i]);
      var from = resFrom[i]["BODY[HEADER.FIELDS (FROM)]"];
      var resTo =
          await inbox.fetch(["BODY.PEEK[HEADER.FIELDS (TO)]"], messageIds: [i]);
      var to = resTo[i]["BODY[HEADER.FIELDS (TO)]"];

      var resBody = await inbox.fetch(["BODY[TEXT]"], messageIds: [i]);
      var body = resBody[i]["BODY[TEXT]"];

      setState(() {
        subjects.add(subject);
        dates.add(date);
        froms.add(from);
        tos.add(to);
        bodies.add(body);
      });
    }
    await client.logout();
    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Carousel(
        height: 459.0,
        width: 300,
        type: "zRotating",
        indicatorType: "dot",
        axis: Axis.horizontal,
        showArrow: false,
        children: List.generate(
          subjects == null
              ? new Container(
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
                            child: Text(
                              '..INBOX GOL..',
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
                )
              : 21,
          (i) => ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 24.0, left: 24, right: 12),
                                child: new Text(
                                  subjects[i].substring(8).toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                            new Text(
                              tos[i],
                              textAlign: TextAlign.center,
                            ),
                            new Divider(),
                            new Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                froms[i],
                                textAlign: TextAlign.center,
                              ),
                            ),
                            new Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(dates[i]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () => showMobilePopup(
                          context: context,
                          builder: (context) => MobilePopUp(
                                title: subjects[i].substring(8).toString(),
                                leadingColor: Colors.white,
                                builder: Builder(
                                  builder: (navigator) => Scaffold(
                                        body: SingleChildScrollView(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: new Text(
                                              bodies[i],
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                        ),
                  );
                },
              ),
        ),
      ),
    );
  }
}
