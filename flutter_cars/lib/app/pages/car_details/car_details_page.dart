import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cars/app/pages/car_details/car_details_bloc.dart';
import 'package:flutter_cars/app/widgets/app_text.dart';
import 'package:flutter_cars/data/repositories/car.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._car.name ?? "Pistons",),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.place),
            onPressed: _onClickMap,
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: _onClickVideo,
          ),
          PopupMenuButton<String>(
            onSelected: (String value) => _onClickPopupMenuItem(value),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: "Edit",
                  child: Text("Edit"),
                ),
                PopupMenuItem(
                  value: "Delete",
                  child: Text("Delete"),
                ),
                PopupMenuItem(
                  value: "Share",
                  child: Text("Share"),
                ),
              ];
            },
          ),
        ],
      ),
      body: _body(),
    );
  }

  _body() {
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
  }

  Row _blockOne() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: 260,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              text(widget._car.name, fontSize: 20, bold: true,),
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
                    return snapshot.data
                        ? IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: Colors.red,
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

  void _onClickVideo() {}

  _onClickPopupMenuItem(final String value) {
    switch (value) {
      case "Edit":
        print("Edit!!!");
        break;
      case "Delete":
        print("Delete!!!");
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

  @override
  void dispose() {
    _carDetailsBloc.dispose();
    super.dispose();
  }
}
