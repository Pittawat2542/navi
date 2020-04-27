import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localstorage/localstorage.dart';
import 'package:Navi/widgets/ActivityCard.dart';

import 'package:Navi/widgets/ActivityCard.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final LocalStorage _storage = new LocalStorage('favorites');

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
        child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('news').snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  return StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection('activity')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot1) {
                        if (snapshot1.hasError)
                          return new Text('Error: ${snapshot1.error}');
                        switch (snapshot1.connectionState) {
                          case ConnectionState.waiting:
                            return new Center(
                              child: CircularProgressIndicator(),
                            );
                          default:
                            return StreamBuilder<QuerySnapshot>(
                                stream: Firestore.instance
                                    .collection('competition')
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot>
                                        snapshot2) {
                                  if (snapshot2.hasError)
                                    return new Text(
                                        'Error: ${snapshot2.error}');
                                  switch (snapshot2.connectionState) {
                                    case ConnectionState.waiting:
                                      return new Center(
                                        child:
                                            CircularProgressIndicator(),
                                      );
                                    default:
                                      return new ListView(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          children: [
                                            ...snapshot.data.documents
                                                .where((DocumentSnapshot
                                                    doc) {
                                              return _storage.getItem(doc
                                                          .documentID) !=
                                                      null
                                                  ? _storage.getItem(doc
                                                          .documentID) ==
                                                      'true'
                                                  : false;
                                            }).map((DocumentSnapshot
                                                    doc) {
                                              return Hero(
                                                tag: doc.documentID
                                                    .toString(),
                                                child: ActivityCard(
                                                  id: doc.documentID,
                                                  title: doc['title'],
                                                  imageUrl:
                                                      doc['imageUrl'],
                                                  category: 'news',
                                                ),
                                              );
                                            }).toList(),
                                            ...snapshot1.data.documents
                                                .where((DocumentSnapshot
                                                    doc) {
                                              return _storage.getItem(doc
                                                          .documentID) !=
                                                      null
                                                  ? _storage.getItem(doc
                                                          .documentID) ==
                                                      'true'
                                                  : false;
                                            }).map((DocumentSnapshot
                                                    doc) {
                                              return Hero(
                                                tag: doc.documentID
                                                    .toString(),
                                                child: ActivityCard(
                                                  id: doc.documentID,
                                                  title: doc['title'],
                                                  imageUrl:
                                                      doc['imageUrl'],
                                                  category: 'activity',
                                                ),
                                              );
                                            }).toList(),
                                            ...snapshot2.data.documents
                                                .where((DocumentSnapshot
                                                    doc) {
                                              return _storage.getItem(doc
                                                          .documentID) !=
                                                      null
                                                  ? _storage.getItem(doc
                                                          .documentID) ==
                                                      'true'
                                                  : false;
                                            }).map((DocumentSnapshot
                                                    doc) {
                                              return Hero(
                                                tag: doc.documentID
                                                    .toString(),
                                                child: ActivityCard(
                                                  id: doc.documentID,
                                                  title: doc['title'],
                                                  imageUrl:
                                                      doc['imageUrl'],
                                                  category: 'competition',
                                                ),
                                              );
                                            }).toList()
                                          ]);
                                  }
                                });
                        }
                      });
              }
            }));
  }
}
//ListView(
//children: [
//Hero(
//tag: 'Ie75XgFvInvcd63ykfeS',
//child: ActivityCard(
//id: 'Ie75XgFvInvcd63ykfeS',
//title: 'SIT CRAFT Camp',
//imageUrl: 'https://www.camphub.in.th/wp-content/uploads/2017/10/sit.png',
//category: 'activity',
//),
//),
//]
//)
