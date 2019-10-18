import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cars/app/pages/car_details/page_state.dart';
import 'package:flutter_cars/app/pages/car_details/car_details_bloc.dart';
import 'package:flutter_cars/app/pages/car_form/car_form_page.dart';
import 'package:flutter_cars/app/pages/favorite_car/favorites_model.dart';
import 'package:flutter_cars/app/pages/home/home_page.dart';
import 'package:flutter_cars/app/pages/login/user.dart';
import 'package:flutter_cars/app/pages/video/video_page.dart';
import 'package:flutter_cars/app/utils/app_colors.dart';
import 'package:flutter_cars/app/utils/dialog.dart';
import 'package:flutter_cars/app/utils/event_bus.dart';
import 'package:flutter_cars/app/utils/nav.dart';
import 'package:flutter_cars/app/widgets/app_text.dart';
import 'package:flutter_cars/data/repositories/car.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CarDetailsPage extends StatefulWidget {
  final Car _car;

  CarDetailsPage(this._car);

  @override
  _CarDetailsPageState createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  final _carDetailsBloc = CarDetailsBloc();

  Car get _car => widget._car;

  @override
  void initState() {
    super.initState();
    _carDetailsBloc.fetch();
    _carDetailsBloc.fetchFavorite(_car);
    _carDetailsBloc.fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blendedRed(),
        title: Text(
          widget._car.name ?? "Pistons",
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.place),
            onPressed: _onClickMap,
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () => _onClickVideo(context),
          ),
          StreamBuilder<User>(
              stream: _carDetailsBloc.userStream,
              builder: (context, snapshot) {
                return PopupMenuButton<String>(
                  onSelected: (String value) => _onClickPopupMenuItem(value),
                  itemBuilder: (context) {
                    final items = [
                      PopupMenuItem(
                        value: "Share",
                        child: Text("Share"),
                      )
                    ];

                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data.isAdmin()) {
                      items.insert(
                        0,
                        PopupMenuItem(
                          value: "Delete",
                          child: Text("Delete"),
                        ),
                      );
                      items.insert(
                        0,
                        PopupMenuItem(
                          value: "Edit",
                          child: Text("Edit"),
                        ),
                      );
                    }
                    return items;
                  },
                );
              }),
        ],
      ),
      body: _body(),
    );
  }

  _body() {
    return StreamBuilder<PageState>(
        stream: _carDetailsBloc.pageStateStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data is Loading) {
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => showCustomLoadingDialog(
                        context,
                        title: snapshot.data.title,
                        message: snapshot.data.message,
                      ));
            } else if (snapshot.data is Success) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pop(context);
                showCustomDialog(context,
                    title: snapshot.data.title,
                    message: snapshot.data.message, onOk: () {
                  EventBus.get(context)
                      .sendEvent(CarEvent("car_delete", _car.type));
                  Navigator.pop(context);
                  push(context, HomePage(), replace: true);
                });
              });
            } else if (snapshot.data is Error) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pop(context);
                showCustomDialog(
                  context,
                  title: snapshot.data.title,
                  message: snapshot.data.message,
                  onOk: () {
                    Navigator.pop(context);
                    push(context, HomePage(), replace: true);
                  },
                );
              });
            }
          }

          return Container(
            padding: EdgeInsets.all(16),
            child: ListView(
              children: <Widget>[
                widget._car.urlPhoto != null
                    ? CachedNetworkImage(
                        imageUrl: widget._car.urlPhoto,
                      )
                    : CachedNetworkImage(
                        imageUrl:
                            "https://cdn0.iconfinder.com/data/icons/shift-travel/32/Speed_Wheel-512.png",
                      ),
                _blockOne(),
                Divider(),
                _blockTwo(),
              ],
            ),
          );
        });
  }

  Row _blockOne() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              text(
                widget._car.name,
                fontSize: 20,
                bold: true,
              ),
              text(widget._car.type, fontSize: 16),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            StreamBuilder<bool>(
                stream: _carDetailsBloc.favoriteStream,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    Provider.of<FavoritesModel>(context, listen: false).fetch();
                    return snapshot.data
                        ? IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: blendedRed(),
                              size: 40,
                            ),
                            onPressed: _onClickUnfavorite,
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.favorite,
                              size: 40,
                            ),
                            onPressed: _onClickFavorite,
                          );
                  }
                  return Container();
                }),
            IconButton(
              icon: Icon(
                Icons.share,
                size: 40,
              ),
              onPressed: _onClickShare,
            ),
          ],
        ),
      ],
    );
  }

  _blockTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        text(widget._car.description, fontSize: 16, bold: true),
        SizedBox(
          height: 20,
        ),
        StreamBuilder<String>(
          stream: _carDetailsBloc.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            }
            return text(snapshot.data, fontSize: 16);
          },
        ),
      ],
    );
  }

  void _onClickMap() {}

  void _onClickVideo(context) {
    if(_car.urlVideo != null && _car.urlVideo.isNotEmpty) {
      //launch(_car.urlVideo);
      push(context, VideoPage(_car));
    } else {
      Fluttertoast.showToast(
          msg: "This car has no video.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          // timeInSecForIos is only used for iOS.
          timeInSecForIos: 1,
          backgroundColor: blendedRed(),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  _onClickPopupMenuItem(final String value) {
    switch (value) {
      case "Edit":
        print("Edit!!!");
        _edit();
        break;
      case "Delete":
        print("Delete!!!");
        _delete();
        break;
      case "Share":
        print("Share!!!");
        break;
    }
  }

  void _onClickFavorite() async {
    _carDetailsBloc.favorite(_car);
  }

  void _onClickUnfavorite() async {
    _carDetailsBloc.unfavorite(_car);
  }

  void _onClickShare() {}

  void _edit() {
    push(
      context,
      CarFormPage(
        car: _car,
      ),
    );
  }

  void _delete() {
    _carDetailsBloc.delete(_car);
  }

  @override
  void dispose() {
    _carDetailsBloc.dispose();
    super.dispose();
  }
}
