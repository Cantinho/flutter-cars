import 'dart:convert';
import 'dart:io';
import 'package:flutter_cars/app/pages/login/user.dart';
import 'package:flutter_cars/data/services/api_response.dart';
import 'package:http/http.dart' as http;

class LoginApi {
  static const _BASE_URL = "http://livrowebservices.com.br/rest";
  static const _BASE_URL_CARS = "https://carros-springboot.herokuapp.com/api/v2";

  /// https://carros.springboot.herokuapp.com/api/v2/login
  /// method: POST
  /// json { "username" : "user", "password" : "123"}
  /// json { "username" : "admin", "password" : "123"}
  ///
  static Future<ApiResponse> login(String login, String password) async {
    try {
      final url = '$_BASE_URL_CARS/login';
      final body = json.encode({
        "username": login,
        "password": password,
      });
      final headers = {
        HttpHeaders.contentTypeHeader: "application/json",
      };
      var response = await http.post(url, body: body, headers: headers);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final Map mapResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        final user = User.fromJson(mapResponse);
        print(">>> $user");
        return ApiResponse.success(user);
      } else {
        return ApiResponse.error(mapResponse["error"]);
      }
    } catch(error, exception) {
      print("Error on login $error > $exception");
      return ApiResponse.error("Server temporarily unavailable.");
    }
  }
}
