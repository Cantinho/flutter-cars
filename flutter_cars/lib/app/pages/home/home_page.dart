import 'package:flutter/material.dart';
import 'package:flutter_cars/data/services/car_api.dart';
import 'package:flutter_cars/data/services/models/Car.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carros'),
      ),
      body: _body(),
    );
  }

  _body() {
    final List<Car> cars = CarApi.fetchCars();

    return Container(
      margin: EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: cars.length,
        itemBuilder: (context, index) {
          final Car car = cars[index];
          return Card(
            color: Colors.grey[100],
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Image.network(
                      car.urlPhoto,
                      width: 250,
                    ),
                  ),
                  Text(
                    car.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 25),
                  ),
                  Text(
                    "description...",
                    style: TextStyle(fontSize: 14),
                  ),
                  ButtonTheme.bar(
                    child: ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('DETAILS'),
                          onPressed: () {},
                        ),
                        FlatButton(
                          child: const Text('SHARE'),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
