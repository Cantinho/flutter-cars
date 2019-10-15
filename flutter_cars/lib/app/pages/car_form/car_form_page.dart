import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cars/app/utils/app_colors.dart';
import 'package:flutter_cars/app/widgets/app_button.dart';
import 'package:flutter_cars/app/widgets/app_circular_button.dart';
import 'package:flutter_cars/app/widgets/app_input_text.dart';
import 'package:flutter_cars/data/repositories/car.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CarFormPage extends StatefulWidget {
  final Car car;

  CarFormPage({this.car});

  @override
  State<StatefulWidget> createState() => _CarroFormPageState();
}

class _CarroFormPageState extends State<CarFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final tName = TextEditingController();
  final tDescription = TextEditingController();
  final tType = TextEditingController();

  int _radioIndex = 0;

  var _showProgress = false;

  Car get car => widget.car;

  // Add validate email function.
  String _validateName(final String value) {
    if (value.isEmpty) {
      return 'Enter the name of the car.';
    }

    return null;
  }

  @override
  void initState() {
    super.initState();

    // Copia os dados do carro para o form
    if (car != null) {
      tName.text = car.name;
      tDescription.text = car.description;
      _radioIndex = getTypeInt(car);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          car != null ? car.name : "New Car",
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: _form(),
      ),
    );
  }

  _form() {
    return Form(
      key: this._formKey,
      child: ListView(
        children: <Widget>[
          _headerPhoto(),
          Text(
            "Click image to take a photo.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Divider(),
          Text(
            "Type",
            style: TextStyle(
              color: blendedRed(),
              fontSize: 20,
            ),
          ),
          _radioType(),
          Divider(),
          AppInputText(
            "Name",
            "",
            controller: tName,
            keyboardType: TextInputType.text,
            validator: _validateName,
          ),
          SizedBox(height: 16),
          AppInputText(
            "Description",
            "",
            controller: tDescription,
            keyboardType: TextInputType.text,
          ),
          AppCircularButton(
            "Save",
            onPressed: _onClickSave,
            showProgress: _showProgress
          ),
        ],
      ),
    );
  }

//  _headerFoto() {
//    return car != null
//        ? CachedNetworkImage(
//      imageUrl: car.urlPhoto,
//    )
//        : Image.asset(
//      "assets/images/camera.png",
//      height: 150,
//    );
//  }

  _headerPhoto() {
    return car != null
        ? CachedNetworkImage(
            imageUrl: car.urlPhoto,
          )
        : SvgPicture.asset(
            "assets/camera.svg",
            height: 150,
            width: 150,
            color: blendedRed(),
            semanticsLabel: 'A red up arrow',
          );
  }

  _radioType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio(
          value: 0,
          groupValue: _radioIndex,
          onChanged: _onClickType,
        ),
        Text(
          "Classic",
          style: TextStyle(color: blendedRed(), fontSize: 15),
        ),
        Radio(
          value: 1,
          groupValue: _radioIndex,
          onChanged: _onClickType,
        ),
        Text(
          "Esport",
          style: TextStyle(color: blendedRed(), fontSize: 15),
        ),
        Radio(
          value: 2,
          groupValue: _radioIndex,
          onChanged: _onClickType,
        ),
        Text(
          "Lux",
          style: TextStyle(color: blendedRed(), fontSize: 15),
        ),
      ],
    );
  }

  void _onClickType(int value) {
    setState(() {
      _radioIndex = value;
    });
  }

  getTypeInt(Car car) {
    switch (car.type) {
      case "classicos":
        return 0;
      case "esportivos":
        return 1;
      default:
        return 2;
    }
  }

  String _getType() {
    switch (_radioIndex) {
      case 0:
        return "classicos";
      case 1:
        return "esportivos";
      default:
        return "luxo";
    }
  }

  _onClickSave() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    // Create car
    var c = car ?? Car();
    c.name = tName.text;
    c.description = tDescription.text;
    c.type = _getType();

    print("Car: $c");

    setState(() {
      _showProgress = true;
    });

    print("Save the car $c");

    await Future.delayed(Duration(seconds: 3));

    setState(() {
      _showProgress = false;
    });

    print("End.");
  }
}