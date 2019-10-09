import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;

void showCustomDialog(
  BuildContext context, {
  @required String title,
  String message,
  String labelOk = "OK",
  String labelCancel,
  @required Function onOk,
  Function onCancel,
}) {
  material.showDialog(
    context: context,
    // barrier dismissible evicts dialog closes screen outside.
    barrierDismissible: false,
    builder: (context) {
      // WillPopScope instead of AlertDialog closes screen outside.
      // alert dialog closes while pushs screen back button.

      final List<Widget> actions = [
        FlatButton(
          child: Text(labelOk),
          onPressed: onOk,
        ),
      ];

      if (labelCancel != null && onCancel != null) {
        actions.insert(
          0,
          FlatButton(
            child: Text(labelCancel),
            onPressed: onCancel,
          ),
        );
      }
      return WillPopScope(
        // Remove onWillPop if using Alert Dialog.
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text(title),
          content: Text(message != null ? message : ""),
          actions: actions,
        ),
      );
    },
  );
}
