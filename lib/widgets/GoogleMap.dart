import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  final double lat;
  final double lng;
  final String name;
  final DocumentSnapshot doc;
  Map(this.lat, this.lng,this.name,this.doc);
  @override
  State<Map> createState() => MapState();
}

class MapState extends State<Map> {

  final Set<Marker> _markers = {};
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
    LatLng targetLocation = new LatLng(widget.lat,widget.lng);
    _markers.add(
      Marker(
        markerId: MarkerId('1'),
        position: targetLocation,
        infoWindow: InfoWindow(
          title: widget.doc['location']['name']
        )
      )
    );
    return GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: targetLocation,
          zoom: 17
        ),
        rotateGesturesEnabled: false,
        scrollGesturesEnabled: false,
        tiltGesturesEnabled: false,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      );
  }

}