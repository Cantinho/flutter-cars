import 'dart:core';

import 'package:flutter/material.dart';

class AppInputText extends StatelessWidget {
  final String label;
  final String hint;
  final bool password;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final FocusNode nextFocus;
  final BuildContext context;

  AppInputText(
    this.label,
    this.hint, {
    this.password = false,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.nextFocus,
    this.context,
   });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: password,
      validator: validator,
      keyboardType: keyboardType,
      focusNode: focusNode,
      onFieldSubmitted: (String text) {
        FocusScope.of(context).requestFocus(nextFocus);
      },
      style: TextStyle(
        fontSize: 18,
        color: Colors.blue,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8)
        ),
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 18,
          color: Colors.grey,
        ),
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}
