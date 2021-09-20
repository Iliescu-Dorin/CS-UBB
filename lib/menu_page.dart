import 'package:UBB/Pages/About/About_page.dart';
import 'package:UBB/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuScreen extends StatelessWidget {
  final String imageUrl = "https://www.ubbcluj.ro/images/logo/logo_cs.png";

  final List<MenuItem> options = [
    MenuItem(Icons.school, 'UBB', "http://www.cs.ubbcluj.ro/"),
    MenuItem(Icons.event, 'Structura', "http://www.cs.ubbcluj.ro/invatamant/structura-anului-universitar/"),
    MenuItem(Icons.assignment, 'Sali',
        "http://www.cs.ubbcluj.ro/files/orar/2018-1/sali/legenda.html"),
    MenuItem(Icons.account_balance, 'AcademicInfo',
        "https://academicinfo.ubbcluj.ro/Info/"),
    MenuItem(Icons.widgets, 'HUB', "https://ubbcluj.onthehub.com/Default.aspx"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 62,
          left: 32,
          bottom: 8,
          right: MediaQuery.of(context).size.width / 2.9),
      color:  Theme.of(context).accentColor,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CircularImage(
                  NetworkImage(imageUrl),
                ),
              ),
              Text(
                'Universitatea',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              )
            ],
          ),
          Text(
            '    Babes-Bolyai',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          Spacer(),
          Column(
            children: options.map((item) {
              return ListTile(
                onTap: () {
                  launch(item.url);
                },
                leading: Icon(
                  item.icon,
                  color: Colors.white,
                  size: 20,
                ),
                title: Text(
                  item.title,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              );
            }).toList(),
          ),
          Spacer(),
          ListTile(
            onTap: () => {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new MyAboutPage()))
            },
            leading: Icon(
              Icons.headset_mic,
              color: Colors.white,
              size: 20,
            ),
            title: Text('Suport',
                style: TextStyle(fontSize: 14, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class MenuItem {
  String title;
  IconData icon;
  String url;
  MenuItem(this.icon, this.title, this.url);
}
