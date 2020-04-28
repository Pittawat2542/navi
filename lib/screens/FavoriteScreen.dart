import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localstorage/localstorage.dart';
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
        title: const Text("Favorites"),
      ),
      body: _buildNormalActivityList(),
    );
  }

  Padding _buildNormalActivityList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('news').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              return StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('activity').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot1) {
                  if (snapshot1.hasError)
                    return Text('Error: ${snapshot1.error}');
                  switch (snapshot1.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    default:
                      return StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection('competition')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot2) {
                          if (snapshot2.hasError)
                            return Text('Error: ${snapshot2.error}');
                          switch (snapshot2.connectionState) {
                            case ConnectionState.waiting:
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            default:
                              int favoriteListLength = snapshot.data.documents
                                      .where(
                                        (DocumentSnapshot doc) {
                                          return _storage.getItem(
                                                      doc.documentID) !=
                                                  null
                                              ? _storage.getItem(
                                                      doc.documentID) ==
                                                  'true'
                                              : false;
                                        },
                                      )
                                      .map(
                                        (DocumentSnapshot doc) {
                                          return Hero(
                                            tag: doc.documentID.toString(),
                                            child: ActivityCard(
                                              id: doc.documentID,
                                              title: doc['title'],
                                              imageUrl: doc['imageUrl'],
                                              category: 'news',
                                              isFavoriteCard: true,
                                            ),
                                          );
                                        },
                                      )
                                      .toList()
                                      .length +
                                  snapshot1.data.documents
                                      .where(
                                        (DocumentSnapshot doc) {
                                          return _storage.getItem(
                                                      doc.documentID) !=
                                                  null
                                              ? _storage.getItem(
                                                      doc.documentID) ==
                                                  'true'
                                              : false;
                                        },
                                      )
                                      .map(
                                        (DocumentSnapshot doc) {
                                          return Hero(
                                            tag: doc.documentID.toString(),
                                            child: ActivityCard(
                                              id: doc.documentID,
                                              title: doc['title'],
                                              imageUrl: doc['imageUrl'],
                                              category: 'activity',
                                              isFavoriteCard: true,
                                            ),
                                          );
                                        },
                                      )
                                      .toList()
                                      .length +
                                  snapshot2.data.documents
                                      .where(
                                        (DocumentSnapshot doc) {
                                          return _storage.getItem(
                                                      doc.documentID) !=
                                                  null
                                              ? _storage.getItem(
                                                      doc.documentID) ==
                                                  'true'
                                              : false;
                                        },
                                      )
                                      .map(
                                        (DocumentSnapshot doc) {
                                          return Hero(
                                            tag: doc.documentID.toString(),
                                            child: ActivityCard(
                                              id: doc.documentID,
                                              title: doc['title'],
                                              imageUrl: doc['imageUrl'],
                                              category: 'competition',
                                              isFavoriteCard: true,
                                            ),
                                          );
                                        },
                                      )
                                      .toList()
                                      .length;
                              return favoriteListLength == 0
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          const Icon(
                                            Icons.info_outline,
                                            size: 64.0,
                                          ),
                                          const SizedBox(
                                            height: 16.0,
                                          ),
                                          const Text(
                                            'No favorites',
                                            style: TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          const Text(
                                              'Keep exploring the app and find your favorite!')
                                        ],
                                      ),
                                    )
                                  : ListView(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      children: [
                                        ...snapshot.data.documents.where(
                                          (DocumentSnapshot doc) {
                                            return _storage.getItem(
                                                        doc.documentID) !=
                                                    null
                                                ? _storage.getItem(
                                                        doc.documentID) ==
                                                    'true'
                                                : false;
                                          },
                                        ).map(
                                          (DocumentSnapshot doc) {
                                            return Hero(
                                              tag: doc.documentID.toString(),
                                              child: ActivityCard(
                                                id: doc.documentID,
                                                title: doc['title'],
                                                imageUrl: doc['imageUrl'],
                                                category: 'news',
                                                isFavoriteCard: true,
                                              ),
                                            );
                                          },
                                        ).toList(),
                                        ...snapshot1.data.documents.where(
                                          (DocumentSnapshot doc) {
                                            return _storage.getItem(
                                                        doc.documentID) !=
                                                    null
                                                ? _storage.getItem(
                                                        doc.documentID) ==
                                                    'true'
                                                : false;
                                          },
                                        ).map(
                                          (DocumentSnapshot doc) {
                                            return Hero(
                                              tag: doc.documentID.toString(),
                                              child: ActivityCard(
                                                id: doc.documentID,
                                                title: doc['title'],
                                                imageUrl: doc['imageUrl'],
                                                category: 'activity',
                                                isFavoriteCard: true,
                                              ),
                                            );
                                          },
                                        ).toList(),
                                        ...snapshot2.data.documents.where(
                                          (DocumentSnapshot doc) {
                                            return _storage.getItem(
                                                        doc.documentID) !=
                                                    null
                                                ? _storage.getItem(
                                                        doc.documentID) ==
                                                    'true'
                                                : false;
                                          },
                                        ).map(
                                          (DocumentSnapshot doc) {
                                            return Hero(
                                              tag: doc.documentID.toString(),
                                              child: ActivityCard(
                                                id: doc.documentID,
                                                title: doc['title'],
                                                imageUrl: doc['imageUrl'],
                                                category: 'competition',
                                                isFavoriteCard: true,
                                              ),
                                            );
                                          },
                                        ).toList()
                                      ],
                                    );
                          }
                        },
                      );
                  }
                },
              );
          }
        },
      ),
    );
  }
}
