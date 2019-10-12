
import 'package:flutter_cars/data/services/models/Car.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

enum CarType {
  classic,
  sport,
  lux
}

String _parseCarType(CarType carType) {
  switch (carType) {

    case CarType.classic:
      return "classicos";
    case CarType.sport:
      return "esportivos";
    case CarType.lux:
      return "luxo";
  }
}

class CarApi {
  static Future<List<Car>> fetchCars(final CarType carType) async {
    final url = "https://carros-springboot.herokuapp.com/api/v1/carros/tipo/${_parseCarType(carType)}";
    print("GET > $url");
    final response = await http.get(url);
    final String json = response.body;
    final List list = convert.json.decode(json);
    final List<Car> cars = list.map<Car>((map) => Car.fromJson(map)).toList();
    return cars;
  }
}