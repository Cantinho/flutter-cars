import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cars/app/pages/home/cars_bloc.dart';
import 'package:flutter_cars/app/pages/home/cars_listview.dart';
import 'package:flutter_cars/app/utils/app_colors.dart';
import 'package:flutter_cars/app/utils/event_bus.dart';
import 'package:flutter_cars/app/widgets/app_text_error.dart';
import 'package:flutter_cars/data/repositories/car.dart';
import 'package:flutter_cars/data/services/car_api.dart';

class CarsPage extends StatefulWidget {
  final CarType carType;

  const CarsPage({Key key, this.carType}) : super(key: key);

  @override
  _CarsPageState createState() => _CarsPageState();
}

class _CarsPageState extends State<CarsPage>
    with AutomaticKeepAliveClientMixin<CarsPage> {
  final _bloc = CarsBloc();

  StreamSubscription<Event> _subscription;

  CarType get _carType => widget.carType;

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
    _bloc.fetch(_carType);
    
    final eventBus = EventBus.get(context);
    _subscription = eventBus.stream.listen((Event event) {
      print("Event $event");
      if (event is CarEvent && event.type == parseCarType(_carType)) {
        _bloc.fetch(_carType);
      }
    });
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
                Container(
                    color: blendedBlack(),
                    child: ListView()),
                AppTextError(
                  "It was not available fetch cars.",
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
            child: cars.isNotEmpty ? CarsListView(cars) :
            Stack(
              children: <Widget>[
                Container(
                    color: blendedBlack(),
                    child: ListView()),
                Container(
                  color: blendedBlack(),
                  margin: EdgeInsets.only(left: 8, right: 8),
                  child: AppTextError(
                    "It was not available fetch cars without internet.",
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
    _subscription.cancel();
  }

  Future<void> _onRefresh() {
    return _bloc.fetch(_carType);
  }
}
