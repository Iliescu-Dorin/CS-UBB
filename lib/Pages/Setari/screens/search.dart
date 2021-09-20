import 'package:UBB/Pages/Setari/widget/superhero.dart';
import 'package:flutter/material.dart';

class HeroSearch extends SearchDelegate {
  final List all;
  HeroSearch({@required this.all});

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 2) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Cautarea trebuie sa fie mai lunga de 1 caracter",
            ),
          )
        ],
      );
    }

    var query1;
    var query2 = " ";
    if (query.length != 0) {
      query1 = query.toLowerCase();
      query2 = query1[0].toUpperCase() + query1.substring(1);
    }
    var query3;
    var query4 = " ";
    if (query.length != 0) {
      query3 = query.toUpperCase();
      query4 = query3[0].toUpperCase() + query3.substring(1);
    }
    //Search in the json for the query entered
    var search = all.where((hero) => hero.name.contains(query2)||hero.name.contains(query4)).toList();

    return search == null
        ? Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          )
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: search == null ? 0 : search.length,
              itemBuilder: (BuildContext context, int position) {
                return SuperHero(
                  name: search[position].name,
                  tip: search[position].tip,
                  web: search[position].web,
                  adress: search[position].adress,
                  domainsOfInterest: search[position].domainsOfInterest,
                  email: search[position].email,
                  photo: search[position].photo,
                );
              },
            ),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var query1;
    var query2 = " ";
    if (query.length != 0) {
      query1 = query.toLowerCase();
      query2 = query1[0].toUpperCase() + query1.substring(1);
    }
    var query3;
    var query4 = " ";
    if (query.length != 0) {
      query3 = query.toUpperCase();
      query4 = query3[0].toUpperCase() + query3.substring(1);
    }
    //Search in the json for the query entered
    var search = all.where((hero) => hero.name.contains(query2)||hero.name.contains(query4)).toList();

    return search == null
        ? Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          )
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: search == null ? 0 : search.length,
              itemBuilder: (BuildContext context, int position) {
                return SuperHero(
                  name: search[position].name,
                  tip: search[position].tip,
                  web: search[position].web,
                  adress: search[position].adress,
                  domainsOfInterest: search[position].domainsOfInterest,
                  email: search[position].email,
                  photo: search[position].photo,
                );
              },
            ),
          );
  }
}
