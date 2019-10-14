import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cars/app/pages/car_details/car_details_page.dart';
import 'package:flutter_cars/app/utils/nav.dart';
import 'package:flutter_cars/data/repositories/car.dart';

class CarsListView extends StatelessWidget {
  final List<Car> _cars;
  final bool favoritePage;

  CarsListView(this._cars, {this.favoritePage = false});

  @override
  Widget build(BuildContext context) {
    return _listView(_cars);
  }

  Container _listView(List<Car> cars) {
    return Container(
      margin: EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: cars != null ? cars.length : 0,
        itemBuilder: (context, index) {
          final Car car = cars[index];
          return Card(
            color: Colors.grey[100],
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: car.urlPhoto != null
                            ? CachedNetworkImage(
                                imageUrl: car.urlPhoto,
                                width: 250,
                              )
                            : CachedNetworkImage(
                                imageUrl:
                                    "https://cdn0.iconfinder.com/data/icons/shift-travel/32/Speed_Wheel-512.png",
                                width: 150,
                              ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        car.name ?? "Pistons",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 25),
                      ),
                      Text(
                        car.description ?? "description...",
                        style: TextStyle(fontSize: 14),
                      ),
                      ButtonTheme.bar(
                        child: ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: const Text('DETAILS'),
                              onPressed: () => _onClickCarDetails(context, car),
                            ),
                            FlatButton(
                              child: const Text('SHARE'),
                              onPressed: () => _onClickCarShare(context, car),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                favoritePage
                    ? Container(
                        margin: EdgeInsets.only(left: 8, top: 8),
                        child: _iconType(car),
                      )
                    : Container(),
              ],
            ),
          );
        },
      ),
    );
  }

  _onClickCarDetails(BuildContext context, Car car) {
    push(context, CarDetailsPage(car));
  }

  _onClickCarShare(BuildContext context, Car car) {
    print("onClickCarShare");
  }

  _iconType(final Car car) {
    print(car.type ?? "nulo");
    switch (car.type) {
      case "classicos":
        {
          return Icon(Icons.directions_car);
        }
      case "esportivos":
        {
          return Icon(Icons.stars);
        }
      case "luxo":
        {
          return Icon(Icons.star);
        }
      default:
        {
          return Container();
        }
    }
  }
}
