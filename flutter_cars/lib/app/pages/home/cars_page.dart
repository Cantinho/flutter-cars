import 'package:flutter/material.dart';
import 'package:flutter_cars/app/pages/car_details/car_details_page.dart';
import 'package:flutter_cars/app/pages/home/cars_bloc.dart';
import 'package:flutter_cars/app/pages/home/cars_listview.dart';
import 'package:flutter_cars/app/utils/nav.dart';
import 'package:flutter_cars/app/widgets/app_text_error.dart';
import 'package:flutter_cars/data/services/car_api.dart';
import 'package:flutter_cars/data/services/models/car.dart';

class CarsPage extends StatefulWidget {
  final CarType carType;

  const CarsPage({Key key, this.carType}) : super(key: key);

  @override
  _CarsPageState createState() => _CarsPageState();
}

class _CarsPageState extends State<CarsPage>
    with AutomaticKeepAliveClientMixin<CarsPage> {
  final _bloc = CarsBloc();

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
  }

  _body() {
    return StreamBuilder(
      stream: _bloc.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return AppTextError(
            "It was not available fetch cars",
          );
        }

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final List<Car> cars = snapshot.data;
        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: CarsListView(cars),
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
      _bloc.fetch(_carType);
    });
  }
}
