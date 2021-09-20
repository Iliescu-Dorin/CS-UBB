import 'package:UBB/Pages/Setari/screens/details.dart';
import 'package:UBB/Pages/Setari/widget/superhero_avatar.dart';
import 'package:flutter/material.dart';

List<SuperHero> profesoriList = new List<SuperHero>();

class SuperHero extends StatelessWidget {
  String name;
  String tip;
  String photo;
  String email;
  String web;
  String adress;
  String domainsOfInterest;

  SuperHero(
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
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        var router = new MaterialPageRoute(builder: (BuildContext context) {
          return Details(
            name: name,
            tip: tip,
            web: web,
            adress: adress,
            domainsOfInterest: domainsOfInterest,
            email: email,
            photo: photo,
          );
        });

        Navigator.of(context).push(router);
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: IntrinsicHeight(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 12.0,
                  ),
                  SuperheroAvatar(img: photo),
                  SizedBox(
                    width: 24.0,
                  ),
                  Expanded(
                    child: Container(
                      // color: Colors.indigo,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "$name",
                            style: textTheme.title,
                          ),
                          Text(
                            tip,
                            style: textTheme.subtitle.copyWith(
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              // Icon(
                              //   Icons.email,
                              //   size: 18.0,
                              // ),
                              // SizedBox(
                              //   width: 2.0,
                              // ),
                              Text(
                                "$email",
                                style: textTheme.caption,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ]),
          ),
        )),
      ),
    );
  }
}
