import '../entities/account.dart';

class Favourite {
  String name;
  String image;

  Account account;

  Map toJson() {
    return {
      "name": name,
      "image": image,
      "account": account,
    };
  }

  Favourite fromJson(Map map) {
    name = map["name"];
    image = map["image"];
    account = Account().fromJson(map["account"]);

    return this;
  }
}
