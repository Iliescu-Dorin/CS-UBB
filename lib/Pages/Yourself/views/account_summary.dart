import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/account_summary.dart';
import '../dummy/accounts.dart';
import '../entities/account.dart';

class AccountSummaryView extends StatefulWidget {
  const AccountSummaryView({Key key,@required this.onSelect}) : super(key: key);
  final ValueChanged<Account> onSelect;

  @override
  State<StatefulWidget> createState() {
    return _AccountSummaryViewState();
  }

}

class _AccountSummaryViewState extends State<AccountSummaryView> {
  int _selectedAccountIndex = 0;

  ScrollController _accountScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.onSelect(Account().fromJson(accounts[_selectedAccountIndex]));

  }

  @override
  Widget build(BuildContext context) {
    return buildAccountSelection(context);
  }

  Widget buildAccountSelection(BuildContext context) {
    double width = 160;
    return ListView.builder(
      controller: _accountScrollController,
      itemBuilder: (context, index) {
        if (index == accounts.length) {
          return Container(
            height: 10,
            width: MediaQuery.of(context).size.width - width - 16,
          );
        }

        Account account = Account().fromJson(accounts[index]);
        CardView cardView = CardView(
          expand: index == _selectedAccountIndex,
          account: account,
          width: width,
          onClick: () {
            _accountScrollController.animateTo(index * (width + 16.0),
                duration: Duration(milliseconds: 200), curve: Curves.linear);
            widget.onSelect(account);
            setState(() {
              _selectedAccountIndex = index;
            });
          },
        );

        return Stack(
          children: [
            cardView,
          ],
        );
      },
      itemCount: accounts.length + 1,
      scrollDirection: Axis.horizontal,
    );
  }

}
