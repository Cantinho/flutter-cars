
import 'package:flutter_cars/data/services/models/Car.dart';

class CarApi {
  static List<Car> fetchCars() {
    final cars = List<Car>();

    cars.add(Car(name: "adillac Deville Convertible", urlPhoto: "http://www.livroandroid.com.br/livro/carros/classicos/Cadillac_Deville_Convertible.png"));
    cars.add(Car(name: "Chevrolet Bel-Air", urlPhoto: "http://www.livroandroid.com.br/livro/carros/classicos/Chevrolet_BelAir.png"));
    cars.add(Car(name: "Ferrari 250 GTO", urlPhoto: "http://www.livroandroid.com.br/livro/carros/classicos/Ferrari_250_GTO.png"));

    return cars;
  }
}