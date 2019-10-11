
import 'package:flutter_cars/data/services/models/Car.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class CarApi {
  static Future<List<Car>> fetchCars() async {
    final url = "https://carros-springboot.herokuapp.com/api/v1/carros";
    print("GET > $url");
    final response = await http.get(url);
    final String json = response.body;
    final List list = convert.json.decode(json);
    final List<Car> cars = List<Car>();
    for(Map map in list) {
      final car = Car.fromJson(map);
      cars.add(car);
    }
    return cars;
  }
}