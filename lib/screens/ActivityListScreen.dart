import 'package:Navi/widgets/ActivityCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ActivityListScreen extends StatefulWidget {
  final String query;
  final String category;

  ActivityListScreen({this.query, this.category});

  @override
  _ActivityListScreenState createState() => _ActivityListScreenState();
}

class _ActivityListScreenState extends State<ActivityListScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.query != null && widget.query.isNotEmpty) {
      return _buildSearchResultActivityList(widget.category);
    }

    return _buildNormalActivityList(widget.category);
  }

  Padding _buildSearchResultActivityList(String category) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<QuerySnapshot>(
        stream:
            Firestore.instance.collection('news').orderBy('title').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              return StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('activity')
                    .orderBy('title')
                    .snapshots(),
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
                            .orderBy('title')
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
                              var temp = [
                                ...snapshot.data.documents
                                    .where((DocumentSnapshot doc) {
                                  return doc['title']
                                      .toString()
                                      .toLowerCase()
                                      .contains(
                                      widget.query.toLowerCase());
                                }).map((DocumentSnapshot document) {
                                  return _buildActivityCard(
                                      document, 'news');
                                }).toList(),
                                ...snapshot1.data.documents
                                    .where((DocumentSnapshot doc) {
                                  return doc['title']
                                      .toString()
                                      .toLowerCase()
                                      .contains(
                                      widget.query.toLowerCase());
                                }).map((DocumentSnapshot document) {
                                  return _buildActivityCard(
                                      document, 'activity');
                                }).toList(),
                                ...snapshot2.data.documents
                                    .where((DocumentSnapshot doc) {
                                  return doc['title']
                                      .toString()
                                      .toLowerCase()
                                      .contains(
                                      widget.query.toLowerCase());
                                }).map((DocumentSnapshot document) {
                                  return _buildActivityCard(
                                      document, 'competition');
                                }).toList()
                              ];
                              return temp.length == 0 ? Center(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Icon(
                                      Icons.cancel,
                                      size: 64.0,
                                    ),
                                    const SizedBox(
                                      height: 16.0,
                                    ),
                                    const Text(
                                      'No results',
                                      style: TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    const Text(
                                        'You may need to try another search term.')
                                  ],
                                ),
                              ) : ListView(
                                      children: temp,
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

  Padding _buildNormalActivityList(String category) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection(category).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              return ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return _buildActivityCard(document, category);
                }).toList(),
              );
          }
        },
      ),
    );
  }

  ActivityCard _buildActivityCard(DocumentSnapshot document, String category) {
    return ActivityCard(
      id: document.documentID,
      title: document["title"],
      imageUrl: document["imageUrl"],
      category: category,
      websiteUrl: document["websiteUrl"],
    );
  }
}
