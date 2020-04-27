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
                  return _buildActivityCard(document, category);
                }).toList(),
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
                return _buildActivityCard(document, category);
              }).toList(),
            );
        }
      },
    ),
  );
  }

  Column _buildActivityCard(DocumentSnapshot document, String category) {
    return Column(
                children: <Widget>[
                  Hero(
                      tag: document.documentID.toString(),
                      child: ActivityCard(
                        id: document.documentID,
                        title: document["title"],
                        imageUrl: document["imageUrl"],
                        category: category,
                      )),
                ],
              );
  }
}
