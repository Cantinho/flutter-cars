import 'package:flutter/material.dart';
import 'package:flutter_cars/app/pages/home/home_page.dart';
import 'package:flutter_cars/app/utils/app_colors.dart';
import 'package:flutter_cars/app/utils/dialog.dart';
import 'package:flutter_cars/app/utils/nav.dart';
import 'package:flutter_cars/app/widgets/app_input_text.dart';
import 'package:flutter_cars/data/services/firebase_service.dart';
//import 'package:firebase_remote_config/firebase_remote_config.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _tNameController = TextEditingController();
  final _tEmailController = TextEditingController();
  final _tPasswordController = TextEditingController();

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _progress = false;

  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Sign Up"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: _body(context),
      ),
    );
  }

  _body(BuildContext context) {

    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          AppInputText('Name', "Insert your name",
              controller: _tNameController,
              validator: _validateName,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              context: context,
              nextFocus: _emailFocus),
          SizedBox(height: 16),
          AppInputText('Email', "Insert your email",
              controller: _tEmailController,
              validator: _validateEmail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              context: context,
              nextFocus: _passwordFocus),
          SizedBox(height: 16),
          AppInputText('Password', "Insert a password",
              controller: _tPasswordController,
              validator: _validatePassword,
              keyboardType: TextInputType.number,
              context: context,
              focusNode: _passwordFocus,
              password: true),
          Container(
            height: 46,
            margin: EdgeInsets.only(top: 20),
            child: RaisedButton(
              color: blendedRed(),
              child: _progress
                  ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              )
                  : Text(
                "Sign up",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              onPressed: () {
                _onClickSignUp(context);
              },
            ),
          ),
          Container(
            height: 46,
            margin: EdgeInsets.only(top: 20),
            child: RaisedButton(
              color: Colors.white,
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: blendedRed(),
                  fontSize: 22,
                ),
              ),
              onPressed: () {
                _onClickCancel(context);
              },
            ),
          ),

        ],
      ),
    );
  }

  String _validateName(String text) {
    if (text.isEmpty) {
      return "Insert your name";
    }

    return null;
  }

  String _validateEmail(String text) {
    if (text.isEmpty) {
      return "Insert your email";
    }

    return null;
  }

  String _validatePassword(String text) {
    if (text.isEmpty) {
      return "Insert a password";
    }
    if (text.length <= 2) {
      return "Password must have more than 2 digits";
    }

    return null;
  }

  _onClickCancel(context) {
    pop(context, "");
  }

  _onClickSignUp(context) async {
    print("Sign Up!");

    String name = _tNameController.text;
    String email = _tEmailController.text;
    String password = _tPasswordController.text;

    print("Name $name, Email $email, Password $password");

    if(!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      _progress = true;
    });

    final firebaseService = FirebaseService();
    final response = await firebaseService.signUp(name, email, password);
    if(response.isSuccess()) {
      push(context, HomePage(), replace: true);
    } else {
      showCustomDialog(context, title: "Sign up", message: response.error,
          onOk: () {
            Navigator.pop(context);
          });
      print("${response.error}");
    }

    setState(() {
      _progress = false;
    });
  }


}
