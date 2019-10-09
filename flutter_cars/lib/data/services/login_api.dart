import 'dart:convert';
import 'dart:io';
import 'package:flutter_cars/app/pages/login/user.dart';
import 'package:http/http.dart' as http;

class LoginApi {
  static const _BASE_URL = "http://livrowebservices.com.br/rest";
  static const _BASE_URL_CARS = "https://carros-springboot.herokuapp.com/api/v2";

  /// https://carros.springboot.herokuapp.com/api/v2/login
  /// method: POST
  /// json { "username" : "user", "password" : "123"}
  /// json { "username" : "admin", "password" : "123"}
  ///
  static Future<User> login(String login, String password) async {
    final url = '$_BASE_URL_CARS/login';
    final body = json.encode({
      "username": login,
      "password": password,
    });
    final headers = {
      HttpHeaders.contentTypeHeader : "application/json",
    };
    var response = await http.post(url, body: body, headers: headers);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final Map mapResponse = json.decode(response.body);
    final user = User.fromJson(mapResponse);
    print(">>> $user");
    return user;
  }
}
