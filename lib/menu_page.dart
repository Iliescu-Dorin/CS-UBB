import 'package:UBB/circular_image.dart';
import 'package:flutter/material.dart';
import './main.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuScreen extends StatelessWidget {
  final String imageUrl = "https://www.ubbcluj.ro/images/logo/logo_cs.png";

  final List<MenuItem> options = [
    MenuItem(Icons.school, 'UBB', "http://www.cs.ubbcluj.ro/"),
    MenuItem(Icons.people, 'Profesori',
        "http://www.cs.ubbcluj.ro/despre-facultate/structura/departamentul-de-informatica/"),
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
      color: Color(0xea1a237e),
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
            onTap: () => {},
            leading: Icon(
              Icons.settings,
              color: Colors.white,
              size: 20,
            ),
            title: Text('Setari',
                style: TextStyle(fontSize: 14, color: Colors.white)),
          ),
          ListTile(
            onTap: () => {},
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
