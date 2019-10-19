import 'dart:convert' as convert;

import 'package:flutter_cars/app/utils/prefs.dart';

class User {
  int id;
  String username;
  String name;
  String email;
  String token;
  String photoUrl;
  List<String> roles;

  User({this.id, this.username, this.name, this.email, this.token, this.photoUrl,
      this.roles});

  User.fromJson(Map<String, dynamic> map)
      : id = map['id'],
        username = map["login"],
        name = map["nome"],
        email = map["email"],
        token = map["token"],
        photoUrl = map["urlFoto"],
        roles = map['roles'] != null ? map['roles'].cast<String>() : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['login'] = this.username;
    data['nome'] = this.name;
    data['email'] = this.email;
    data['urlFoto'] = this.photoUrl;
    data['token'] = this.token;
    data['roles'] = this.roles;
    return data;
  }

  @override
  String toString() {
    return 'User{id: $id, String: $String, name: $name, email: $email, token: $token, photoUrl: $photoUrl, roles: $roles}';
  }

  bool isAdmin() {
    if(roles != null && roles.contains("ROLE_ADMIN")) {
      return true;
    }
    return false;
  }

  void save() {
    final Map map = toJson();
    final String json = convert.json.encode(map);
    Prefs.setString("user.prefs", json);
  }

  static Future<User> get() async {
    final String json = await Prefs.getString("user.prefs");
    if(json.isEmpty) {
      return null;
    }
    final Map map = convert.json.decode(json);
    final User user = User.fromJson(map);
    return user;
  }

  static void clear() {
    Prefs.setString("user.prefs", "");
  }

}
