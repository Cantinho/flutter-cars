import 'package:flutter/material.dart';
import 'package:flutter_cars/app/utils/app_colors.dart';

class AppCircularButton extends StatelessWidget {
  final String _label;
  final Function onPressed;
  final bool showProgress;

  AppCircularButton(this._label,
      {@required this.onPressed, @required this.showProgress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      margin: EdgeInsets.only(top: 20),
      child: RaisedButton(
        color: blendedRed(),
        child: showProgress
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : Text(
                _label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
        onPressed: !showProgress ? onPressed : () {},
      ),
    );
  }
}
