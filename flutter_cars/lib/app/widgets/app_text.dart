import 'package:flutter/material.dart';

Text text(
  String content, {
  double fontSize = 16,
  color = Colors.black,
  bold = false,
}) {
  return Text(
    content ?? "",
    style: TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    ),
  );
}
