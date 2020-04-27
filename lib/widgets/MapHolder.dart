import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Navi/widgets/GoogleMap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapHolder extends StatelessWidget {
  final double targetLat;
  final double targetLng;
  final String targetName;
  final DocumentSnapshot doc;

  MapHolder(
      {@required this.targetLat,
      @required this.targetLng,
      @required this.targetName,
      @required this.doc});

  @override
  Widget build(BuildContext context) {
    print(targetLat);
    print(targetLng);
    print(targetName);
    return Map(targetLat, targetLng, targetName,doc);
  }
}
