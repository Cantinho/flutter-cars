import 'package:flutter/material.dart';
import 'package:flutter_cars/app/utils/app_colors.dart';

class AppButton extends StatelessWidget {
  final String label;
  final Function onPressed;

  AppButton(this.label, {@required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      child: RaisedButton(
        color: blendedRed(),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }

}
