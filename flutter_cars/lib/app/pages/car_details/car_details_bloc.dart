

import 'dart:async';

import 'package:flutter_cars/data/services/LoripsumApi.dart';

class CarDetailsBloc {

  final _streamController = StreamController<String>();

  Stream<String> get stream => _streamController.stream;

  fetch() async {
    String content = await LoripsumApi.getLoripsum();
    _streamController.add(content);
  }

  void dispose() {
    _streamController.close();
  }
}