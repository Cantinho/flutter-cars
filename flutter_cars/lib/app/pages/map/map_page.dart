import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cars/data/repositories/car.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final Car _car;

  MapPage(this._car);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  bool showGoogleMountainView = false;

  static final LatLng _mountainViewPosition = LatLng(37.423021,  -122.083739);
  static final CameraPosition _mountainView = CameraPosition(
      bearing: 192.8334901395799,
      target: _mountainViewPosition,
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._car.name ?? "Car location"),
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the Google!'),
        icon: Icon(Icons.directions_car),
      ),
    );
  }

  _body() {
    return Container(
      child: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          zoom: 17,
          target: _carLatLng(),
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set.of(_getMarkers()),
      ),
    );
  }

  _carLatLng() {
    print("car location: lat:${widget._car.latitude ?? 0.0}, lng:${widget._car.longitude ?? 0.0}");
    return LatLng(
      widget._car.latitude != null || widget._car.latitude.isEmpty
          ? 0.0
          : double.parse(widget._car.latitude),
      widget._car.longitude != null || widget._car.longitude.isEmpty
          ? 0.0
          : double.parse(widget._car.longitude),
    );
  }

  List<Marker> _getMarkers() {
    List<Marker> markers = [];
    if (showGoogleMountainView) {
      markers.add(_googleMarker());
    } else {
      markers.add(_carMarker());
    }
    return markers;
  }

  Marker _googleMarker() {
    return Marker(
        markerId: MarkerId("2"),
        position: _mountainViewPosition,
        infoWindow: InfoWindow(
          title: "Google Mountain View",
          snippet: "The best company to work!",
          onTap: () {
            print("on window clicked");
          },
        ),
        onTap: () {
          print("on marker clicked");
        });
  }

  Marker _carMarker() {
    return Marker(
        markerId: MarkerId("${widget._car.id}"),
        position: _carLatLng(),
        infoWindow: InfoWindow(
          title: widget._car.name ?? "Car",
          snippet: "${widget._car.name ?? ""} factory",
          onTap: () {
            print("on window clicked");
          },
        ),
        onTap: () {
          print("on marker clicked");
        });
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_mountainView));
    setState(() {
      showGoogleMountainView = true;
    });
  }
}
