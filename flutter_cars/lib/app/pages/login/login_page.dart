import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_cars/app/pages/home/home_page.dart';
import 'package:flutter_cars/app/pages/login/login_bloc.dart';
import 'package:flutter_cars/app/pages/sign_up/sign_up_page.dart';
import 'package:flutter_cars/app/utils/app_colors.dart';
import 'package:flutter_cars/app/utils/dialog.dart';
import 'package:flutter_cars/app/utils/nav.dart';
import 'package:flutter_cars/app/widgets/app_button.dart';
import 'package:flutter_cars/app/widgets/app_input_text.dart';
import 'package:flutter_cars/data/services/api_response.dart';
import 'package:flutter_cars/data/services/firebase_service.dart';

class LoginPage extends StatefulWidget {
  static const MIN_PASSWORD_LENGTH = 3;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _tLoginController = TextEditingController();

  final _tPasswordController = TextEditingController();

  final _passwordFocus = FocusNode();

  final _bloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blendedRed(),
        title: Text("Pistons"),
      ),
      body: _body(),
    );
  }

  _body() {
    return StreamBuilder<bool>(
        stream: _bloc.stream,
        initialData: false,
        builder: (context, snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              snapshot.data
                  ? LinearProgressIndicator(
                      backgroundColor: Colors.grey,
                    )
                  : Container(),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: Container(
                    margin: EdgeInsets.all(16),
                    child: ListView(
                      children: <Widget>[
                        AppInputText('E-mail', "Insert your best e-mail",
                            controller: _tLoginController,
                            validator: _validateLogin,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            context: context,
                            nextFocus: _passwordFocus),
                        SizedBox(height: 16),
                        AppInputText('Password', "Insert a string password",
                            controller: _tPasswordController,
                            validator: _validatePassword,
                            keyboardType: TextInputType.number,
                            context: context,
                            focusNode: _passwordFocus,
                            password: true),
                        SizedBox(height: 16),
                        AppButton("Login", onPressed: _onClickLogin),
                        SizedBox(
                          height: 16,
                        ),
                        GoogleSignInButton(
                          onPressed: _onClickGoogleLogin,
                        ),
                        Container(
                          height: 46,
                          margin: EdgeInsets.only(top: 16),
                          child: InkWell(
                            onTap: () => _onClickSignUp(context),
                            child: Text(
                              "Sign-up",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: blendedRed(),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        });
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

  void _onClickLogin() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }

    final String login = _tLoginController.text;
    final String password = _tPasswordController.text;
    print("Login :$login, Password:$password");
    final ApiResponse response = await _bloc.login(login, password);
    if (response.isSuccess()) {
      push(context, HomePage(), replace: true);
    } else {
      showCustomDialog(context, title: "Cars", message: response.error,
          onOk: () {
        Navigator.pop(context);
      });
      print("Incorrect password");
    }
  }

  void _onClickGoogleLogin() async {
    final service = FirebaseService();
    ApiResponse response = await service.loginGoogle();

    if (response.isSuccess()) {
      push(context, HomePage(), replace: true);
    } else {
      showCustomDialog(context, title: "Cars", message: response.error,
          onOk: () {
        Navigator.pop(context);
      });
      print("${response.error}");
    }
  }

  _onClickSignUp(final BuildContext context) {
    push(context, SignUpPage());
  }

  @override
  void dispose() {
    _bloc.dispose();
    _tLoginController.dispose();
    _tPasswordController.dispose();
    super.dispose();
  }


}
