import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'MovieDetail.dart';
import 'MovieResModel.dart';

/*
Movie Item Layout for the ListView
 */
class MovieItem extends StatelessWidget {
  final PostResponse data;

  /*
   * movie object 
   */
  MovieItem({@required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      // Card
      shape: RoundedRectangleBorder(
        // shape of the card
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 8.0,
      margin: EdgeInsets.only(left:16.0,right:16.0 ,bottom:32.0),
      child: InkWell(
        //for listening for gestures without ink splashes.
        radius: 8.0,
        child: getCardView(context),
        onTap: () {
          //This widget is used to navigate from one screen to another
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetail(
                data: data,
              ),
            ),
          );
        },
      ),
    );
  }

  /*
  Returns the column containing card layout for the item list
   */
  getCardView(BuildContext context) {
    return Column(
      // Column start
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Hero(
          // To do the animation
          tag: data.title, // must be unique for the proper animation
          child: Container(
            //container for giving border to the image
            height: 150.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                  image: NetworkImage(
                    data.image,
                  ),
                  fit: BoxFit.fitWidth),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                data.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.title,
              ),
              Text(
                data.detalii,
                softWrap: true,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.body2,
              ),
              Divider(),
              Center(
                child: new Text(
                  data.date,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
