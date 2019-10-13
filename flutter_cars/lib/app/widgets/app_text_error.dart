import 'package:flutter/material.dart';

class AppTextError extends StatelessWidget {
  final String _message;

  AppTextError(this._message);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _message,
        style: TextStyle(
          color: Colors.red,
          fontSize: 22,
        ),
      ),
    );
  }
}
