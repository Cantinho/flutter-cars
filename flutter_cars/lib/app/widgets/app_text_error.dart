import 'package:flutter/material.dart';

class AppTextError extends StatelessWidget {
  final String _message;
  final Color color;

  AppTextError(this._message, {this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _message,
        style: TextStyle(
          color: color,
          fontSize: 22,
        ),
      ),
    );
  }
}
