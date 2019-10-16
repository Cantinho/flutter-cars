

import 'dart:async';
import 'package:flutter_cars/app/pages/login/user.dart';
import 'package:flutter_cars/app/utils/network.dart' as networkUtils;
import 'package:flutter_cars/data/repositories/car_dao.dart';
import 'package:flutter_cars/data/services/car_api.dart';
import 'package:flutter_cars/data/repositories/car.dart';

class HomePageBloc {

  final _streamController = StreamController<User>();

  Stream<User> get stream => _streamController.stream;

  fetchUser() async {
    final User user = await User.get();
    _streamController.add(user);
  }

  void dispose() {
    _streamController.close();
  }
}