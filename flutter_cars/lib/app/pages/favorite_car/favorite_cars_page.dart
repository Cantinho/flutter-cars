import 'package:flutter/material.dart';
import 'package:flutter_cars/app/pages/car_details/car_details_page.dart';
import 'package:flutter_cars/app/pages/favorite_car/favorite_cars_bloc.dart';
import 'package:flutter_cars/app/pages/home/cars_bloc.dart';
import 'package:flutter_cars/app/pages/home/cars_listview.dart';
import 'package:flutter_cars/app/utils/app_colors.dart';
import 'package:flutter_cars/app/utils/nav.dart';
import 'package:flutter_cars/app/widgets/app_text_error.dart';
import 'package:flutter_cars/data/services/car_api.dart';
import 'package:flutter_cars/data/repositories/car.dart';

class FavoriteCarsPage extends StatefulWidget {
  @override
  _FavoriteCarsPageState createState() => _FavoriteCarsPageState();
}

class _FavoriteCarsPageState extends State<FavoriteCarsPage>
    with AutomaticKeepAliveClientMixin<FavoriteCarsPage> {
  final _bloc = FavoriteCarsBloc();

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
    _bloc.fetch();
  }

  _body() {
    return StreamBuilder(
      stream: _bloc.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
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

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final List<Car> cars = snapshot.data ?? [];
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
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  Future<void> _onRefresh() {
    return Future.delayed(Duration(seconds: 3), () {
      print("onRefresh: finished");
      _bloc.fetch();
    });
  }
}
