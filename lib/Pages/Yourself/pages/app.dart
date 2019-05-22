import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../main.dart';
import '../components/bottom_sheet.dart';
import '../entities/account.dart';
import '../entities/favourite.dart';
import '../utils/assets.dart';
import '../views/account_summary.dart';
import '../views/favourite_list.dart';
import '../views/transaction.dart';
import '../views/transition_bottom_sheet.dart';

class AppPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppPageState();
  }
}

class _AppPageState extends State<AppPage> {
  Account _selectedAccount;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: InkWell(child: Image(image: Assets.image("menu.png"),),onTap:  () => {
                Navigator.pop(context),
              },),
        actions: <Widget>[
          Image(
            image: Assets.image("bell.png"),
          ),
          Container(
            margin: EdgeInsets.only(right: 16, top: 10, bottom: 10),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: Assets.image("user1.jpg"), fit: BoxFit.cover)),
            width: 36,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height+200,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 24),
                height: 240,
                child: AccountSummaryView(
                  onSelect: (account) => _selectedAccount = account,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "Profesori",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.transparent,
                  scaffoldBackgroundColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  dialogBackgroundColor: Colors.transparent,
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                      background: Colors.transparent,
                      surface: Colors.transparent),
                ),
                child: Builder(
                  builder: (context) => FavouriteListView(
                        onSelect: (account) =>
                            showFavouriteInfo(context, account),
                      ),
                ),
              ),
              Container(
                height: 30,
              ),
              Expanded(
                flex: 1,
                child: TransactionsView(),
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
      ),
    );
  }

  void showFavouriteInfo(BuildContext context, Favourite favourite) {
    showModalBottomSheetApp(
      context: context,
      builder: (context) => TransitionBottomSheetView(
          account: _selectedAccount, favourite: favourite),
    );
  }
}
