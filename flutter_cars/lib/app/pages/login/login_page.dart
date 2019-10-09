import 'package:flutter/material.dart';
import 'package:flutter_cars/app/widgets/app_button.dart';
import 'package:flutter_cars/app/widgets/app_input_text.dart';

class LoginPage extends StatefulWidget {
  static const MIN_PASSWORD_LENGTH = 4;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _tLoginController = TextEditingController();

  final _tPasswordController = TextEditingController();

  final _passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cars"),
      ),
      body: _body(),
    );
  }

  _body() {
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            AppInputText(
              'E-mail',
              "Insert your best e-mail",
              controller: _tLoginController,
              validator: _validateLogin,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              context: context,
              nextFocus: _passwordFocus
            ),
            SizedBox(height: 8),
            AppInputText('Password', "Insert a string password",
                controller: _tPasswordController,
                validator: _validatePassword,
                keyboardType: TextInputType.number,
                context: context,
                focusNode: _passwordFocus,
                password: true),
            SizedBox(height: 16),
            AppButton("Login", onPressed: _onClickLogin)
          ],
        ),
      ),
    );
  }

  String _validateLogin(String text) {
    if (text.isEmpty) {
      return "Insert the text";
    }
    return null;
  }

  String _validatePassword(String text) {
    if (text.isEmpty) {
      return "Insert the password";
    }

    if (text.length < LoginPage.MIN_PASSWORD_LENGTH) {
      return "The password must contains at least ${LoginPage.MIN_PASSWORD_LENGTH}";
    }
    return null;
  }

  void _onClickLogin() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    final String login = _tLoginController.text;
    final String password = _tPasswordController.text;
    print("Login :$login, Password:$password");
  }
}
