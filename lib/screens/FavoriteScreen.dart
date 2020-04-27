import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localstorage/localstorage.dart';

import 'package:Navi/widgets/ActivityCard.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  //TODO: Add logic to load item from local storage and show all activity cards

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
      ),
      body: _buildNormalActivityList(),
    );
  }

  Padding _buildNormalActivityList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
          children: [
            Hero(
              tag: 'Ie75XgFvInvcd63ykfeS',
              child: ActivityCard(
                id: 'Ie75XgFvInvcd63ykfeS',
                title: 'SIT CRAFT Camp',
                imageUrl: 'https://www.camphub.in.th/wp-content/uploads/2017/10/sit.png',
                category: 'activity',
              ),
            ),
          ]
      )
      ,
    );
  }
}

