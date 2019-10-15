import 'dart:io';
import 'package:flutter_cars/app/pages/login/user.dart';
import 'package:flutter_cars/data/repositories/car_dao.dart';
import 'package:flutter_cars/data/repositories/car.dart';
import 'package:flutter_cars/data/services/api_response.dart';
import 'package:flutter_cars/data/services/models/car_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

enum CarType { classic, sport, lux }

String parseCarType(CarType carType) {
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
        "https://carros-springboot.herokuapp.com/api/v2/carros/tipo/${parseCarType(carType)}";
    print("GET > $url");

    final User user = await User.get();
    final Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${user.token}",
    };

    final response = await http.get(url, headers: headers);
    final String json = response.body;

    final List list = convert.json.decode(json);
    final List<Car> cars = list
        .map<Car>((map) => CarResponse.parseFrom(CarResponse.fromJson(map)))
        .toList();

    if (cars.isNotEmpty) {
      final dao = CarDAO();
      cars.forEach(dao.save);
    }

    return cars;
  }

  static Future<ApiResponse<bool>> save(final Car car) async {
    try {
      final User user = await User.get();

      final Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer ${user.token}"
      };

      var url = 'https://carros-springboot.herokuapp.com/api/v2/carros';
      if (car.id != null) {
        url += "/${car.id}";
      }

      print("POST > $url");

      final String json = CarResponse.fromCar(car).toJson();
      print("   JSON > $json");

      final response = await (car.id == null
          ? http.post(url, body: json, headers: headers)
          : http.put(url, body: json, headers: headers));

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map mapResponse = convert.json.decode(response.body);

        Car carro = Car.fromMap(mapResponse);

        print("Novo carro: ${carro.id}");

        return ApiResponse.success(true);
      }

      if (response.body == null || response.body.isEmpty) {
        return ApiResponse.error("Não foi possível salvar o carro");
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(mapResponse["error"]);
    } catch (e) {
      print(e);

      return ApiResponse.error("Não foi possível salvar o carro");
    }
  }
}
