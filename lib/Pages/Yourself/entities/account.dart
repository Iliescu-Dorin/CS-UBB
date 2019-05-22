import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Account {
  String name;
  String cardNumber;
  Color color;

  String validThru;

  double amount;

  int months;

  String getLastCardNumber() {
    if (cardNumber == null) return "";
    List l = cardNumber.split(" ");
    return l[l.length - 1];
  }

  String getAmountInString() {
    return "\$${NumberFormat("#,###.00").format(amount).replaceAll(",", " ")}";
  }

  Map toJson() {
    return {
      "name": name,
      "card_number": cardNumber,
      "color": color,
      "valid_thru": validThru,
      "amount": amount,
      "months": months,
    };
  }

  Account fromJson(map) {
    name = map["name"];
    cardNumber = map["card_number"];
    color = map["color"];
    validThru = map["valid_thru"];
    amount = map["amount"];
    months = map["months"];

    return this;
  }
}
