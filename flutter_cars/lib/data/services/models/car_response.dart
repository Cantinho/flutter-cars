import 'dart:convert' as convert;
import 'package:flutter_cars/data/repositories/car.dart';

class CarResponse {
  int id;
  String name;
  String type;
  String description;
  String urlPhoto;
  String urlVideo;
  String latitude;
  String longitude;

  CarResponse(
      {this.id,
      this.name,
      this.type,
      this.description,
      this.urlPhoto,
      this.urlVideo,
      this.latitude,
      this.longitude});

  CarResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['nome'];
    type = json['tipo'];
    description = json['descricao'];
    urlPhoto = json['urlFoto'];
    urlVideo = json['urlVideo'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.name;
    data['tipo'] = this.type;
    data['descricao'] = this.description;
    data['urlFoto'] = this.urlPhoto;
    data['urlVideo'] = this.urlVideo;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }

  static Car parseFrom(CarResponse carResponse) {
    final Car car = Car(
        id: carResponse.id,
        name: carResponse.name,
        type: carResponse.type,
        description: carResponse.description,
        urlPhoto: carResponse.urlPhoto,
        urlVideo: carResponse.urlVideo,
        latitude: carResponse.latitude,
        longitude: carResponse.longitude);

    return car;
  }

  CarResponse.fromCar(final Car car) {
    id = car.id;
    name = car.name;
    type = car.type;
    description = car.description;
    urlPhoto = car.urlPhoto;
    urlVideo = car.urlVideo;
    latitude = car.latitude;
    longitude = car.longitude;
  }

  String toJson() {
    String json = convert.json.encode(toMap());
    return json;
  }
}
