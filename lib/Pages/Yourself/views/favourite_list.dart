import 'dart:ui';

import 'package:UBB/Pages/Setari/widget/superhero.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../main.dart';
import '../dummy/favourites.dart';
import '../utils/assets.dart';

class FavouriteListView extends StatefulWidget {
  const FavouriteListView({Key key, @required this.onSelect}) : super(key: key);

  final ValueChanged<SuperHero> onSelect;

  @override
  State<StatefulWidget> createState() {
    return _FavouriteListViewState();
  }
}

class _FavouriteListViewState extends State<FavouriteListView> {
  ScrollController _favouriteScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildFavourites(context);
  }

  buildFavourites(BuildContext context) {
    return Container(
      height: 84,
      child: ListView.builder(
        controller: _favouriteScrollController,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          // if (index == 0)
          //   return Container(
          //     margin: EdgeInsets.only(left: 20, bottom: 4, top: 20),
          //     child: Image(image: Assets.image("add.png")),
          //   );
          // else
          // if (index == favourites.length+1)
          //   return Container(
          //     width: 20,
          //   );
          //!scos add-ul : "modificat itemcount + 2" si favorites[index-1]
          // Favourite favourite = Favourite().fromJson(favourites[index]);
          SuperHero yourProf = yourProfesors[index];
          return GestureDetector(
            onTap: () {
              _favouriteScrollController.animateTo(index * 84.0,
                  duration: Duration(milliseconds: 200), curve: Curves.linear);
              widget.onSelect(yourProf);
            },
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              margin: EdgeInsets.only(left: 10,right:5, top: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Image(
                image: NetworkImage(yourProf.photo),
                fit: BoxFit.cover,
                width: 64,
                height: 64,
              ),
            ),
          );
        },
        itemCount: yourProfesors.length,
      ),
    );
  }
}
