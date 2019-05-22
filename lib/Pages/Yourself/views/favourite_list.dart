import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../dummy/favourites.dart';
import '../entities/favourite.dart';
import '../utils/assets.dart';

class FavouriteListView extends StatefulWidget {
  const FavouriteListView({Key key, @required this.onSelect}) : super(key: key);

  final ValueChanged<Favourite> onSelect;

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
          if (index == 0)
            return Container(
              margin: EdgeInsets.only(left: 20, bottom: 4, top: 20),
              child: Image(image: Assets.image("add.png")),
            );
          else if (index == favourites.length + 1)
            return Container(
              width: 20,
            );

          Favourite favourite = Favourite().fromJson(favourites[index - 1]);
          return GestureDetector(
            onTap: () {
              _favouriteScrollController.animateTo(index * 84.0,
                  duration: Duration(milliseconds: 200), curve: Curves.linear);
              widget.onSelect(favourite);
            },
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              margin: EdgeInsets.only(left: 20, bottom: 4, top: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Image(
                image: Assets.image(favourite.image),
                fit: BoxFit.cover,
                width: 64,
                height: 64,
              ),
            ),
          );
        },
        itemCount: favourites.length + 2,
      ),
    );
  }
}
