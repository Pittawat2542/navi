import 'package:Navi/widgets/ActivityCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ActivityListScreen extends StatefulWidget {
  final String query;

  //TODO: Add support for category

  ActivityListScreen({this.query});

  @override
  _ActivityListScreenState createState() => _ActivityListScreenState();
}

class _ActivityListScreenState extends State<ActivityListScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.query != null && widget.query.isNotEmpty) {
      return _buildSearchResultActivityList();
    }

    //TODO: Support category here

    return _buildNormalActivityList();
  }

  Padding _buildSearchResultActivityList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('activity')
            .orderBy('title')
            .where('title', isGreaterThanOrEqualTo: widget.query)
            .where('title', isLessThanOrEqualTo: widget.query + '\uF7FF')
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Center(
                child: CircularProgressIndicator(),
              );
            default:
              return new ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return Column(
                    children: <Widget>[
                      Hero(
                          tag: document.documentID.toString(),
                          child: ActivityCard(
                            id: document.documentID,
                            title: document["title"],
                            imageUrl: document["imageUrl"],
                          )),
                    ],
                  );
                }).toList(),
              );
          }
        },
      ),
    );
  }

  Padding _buildNormalActivityList() {
    return Padding(
    padding: const EdgeInsets.all(16.0),
    child: StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('activity').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(
              child: CircularProgressIndicator(),
            );
          default:
            return new ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                return Column(
                  children: <Widget>[
                    Hero(
                        tag: document.documentID.toString(),
                        child: ActivityCard(
                          id: document.documentID,
                          title: document["title"],
                          imageUrl: document["imageUrl"],
                        )),
                  ],
                );
              }).toList(),
            );
        }
      },
    ),
  );
  }
}
