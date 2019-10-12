import 'dart:io';
import 'package:flutter_cars/app/pages/login/user.dart';
import 'package:flutter_cars/data/services/models/Car.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

enum CarType { classic, sport, lux }

String _parseCarType(CarType carType) {
  switch (carType) {
    case CarType.classic:
      return "classicos";
    case CarType.sport:
      return "esportivos";
    case CarType.lux:
      return "luxo";
  }
  return "";
}

class CarApi {
  static Future<List<Car>> fetchCars(final CarType carType) async {
    final url =
        "https://carros-springboot.herokuapp.com/api/v2/carros/tipo/${_parseCarType(carType)}";
    print("GET > $url");

    final User user = await User.get();
    final Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${user.token}",
    };

    final response = await http.get(url, headers: headers);
    final String json = response.body;

    final List list = convert.json.decode(json);
    final List<Car> cars = list.map<Car>((map) => Car.fromJson(map)).toList();
    return cars;
  }
}
