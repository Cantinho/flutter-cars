

import 'dart:async';

import 'package:flutter_cars/app/pages/login/user.dart';
import 'package:flutter_cars/data/services/api_response.dart';
import 'package:flutter_cars/data/services/login_api.dart';

class LoginBloc {

  final _streamController = StreamController<bool>();

  get stream => _streamController.stream;

  Future<ApiResponse> login(final String login, final String password) async {
    _streamController.add(true);
    final ApiResponse response = await LoginApi.login(login, password);
    _streamController.add(false);
    return response;
  }

  void dispose() {
    _streamController.close();
  }

}