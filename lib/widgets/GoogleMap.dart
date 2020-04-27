import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  final double lat;
  final double lng;
  final String name;
  Map(this.lat, this.lng,this.name);
  @override
  State<Map> createState() => MapState();
}

class MapState extends State<Map> {
//  LatLng targetLocation = new LatLng(widget.lat, widget.lng);
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kKMUTT = CameraPosition(
    target: LatLng(13.650888,100.4918183),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(13.6494, 100.4929),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kKMUTT,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      );
  }

}