import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cars/app/pages/favorite_car/favorites_model.dart';
import 'package:flutter_cars/app/pages/home/cars_listview.dart';
import 'package:flutter_cars/app/utils/app_colors.dart';
import 'package:flutter_cars/app/utils/event_bus.dart';
import 'package:flutter_cars/app/widgets/app_text_error.dart';
import 'package:flutter_cars/data/repositories/car.dart';
import 'package:provider/provider.dart';

class FavoriteCarsPage extends StatefulWidget {
  var forceReload;

  FavoriteCarsPage([this.forceReload]);

  @override
  _FavoriteCarsPageState createState() => _FavoriteCarsPageState();

}

class _FavoriteCarsPageState extends State<FavoriteCarsPage>
    with AutomaticKeepAliveClientMixin<FavoriteCarsPage> {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _body();
  }

  @override
  void initState() {
    super.initState();
    final favoritesModel = Provider.of<FavoritesModel>(context, listen: false);
    favoritesModel.fetch();
  }

  _body() {

    FavoritesModel model = Provider.of<FavoritesModel>(context);
    if(widget.forceReload != null && widget.forceReload) {
      model.fetch();
      setState(() {
        widget.forceReload = false;
      });
    }
    List<Car> cars = model.cars;
    if(cars.isEmpty) {
      return RefreshIndicator(
        backgroundColor: blendedRed(),
        color: white(),
        onRefresh: _onRefresh,
        child: Stack(
          children: <Widget>[
            Container(color: blendedBlack(), child: ListView()),
            AppTextError(
              "No favorite car.",
            )
          ],
        ),
      );
    }

    return RefreshIndicator(
      backgroundColor: blendedRed(),
      color: white(),
      onRefresh: _onRefresh,
      child: Container(
        color: blendedBlack(),
        child: cars.isNotEmpty
            ? CarsListView(
          cars,
          favoritePage: true,
        )
            : Stack(
          children: <Widget>[
            Container(child: ListView()),
            Container(
              margin: EdgeInsets.only(left: 8, right: 8),
              child: AppTextError(
                "No favorite car.",
              ),
            )
          ],
        ),
      ),
    );

  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _onRefresh() {
    return Provider.of<FavoritesModel>(context,listen: false).fetch();
  }
}
