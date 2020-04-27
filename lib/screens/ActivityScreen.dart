import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share/share.dart';

import 'package:Navi/widgets/ActivityCard.dart';
import 'package:Navi/widgets/MapHolder.dart';

class ActivityScreen extends StatefulWidget {
  final String activityId;
  final String category;
  final String title;

  ActivityScreen(this.activityId, this.title, this.category);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  bool isFavorite = false;
  bool isAboutOrDetail = true;

  @override
  Widget build(BuildContext context) {
    if (widget.activityId != null) {
      return Scaffold(
        appBar: _buildAppBar(context, widget.title),
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance
                    .collection(widget.category)
                    .document(widget.activityId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return new Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var document = snapshot.data;
                  var date = new DateTime.fromMillisecondsSinceEpoch(
                      document['activityStartDateTime'].seconds * 1000);
                  return Column(
                    children: [
                      Hero(
                        tag: document.documentID.toString(),
                        child: ActivityCard(
                          id: document.documentID,
                          title: document["title"],
                          imageUrl: document["imageUrl"],
                          height: 228,
                          isActivityDetail: true,
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          isAboutOrDetail
                              ? _buildAboutTabActive()
                              : _buildAboutTabInactive(),
                          isAboutOrDetail
                              ? _buildDetailInactive()
                              : _buildDetailActive()
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      isAboutOrDetail
                          ? _buildAboutContent(date, document)
                          : _buildDetailContent(document)
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
  }

  AppBar _buildAppBar(BuildContext context, String title) {
    return AppBar(
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.favorite,
            color: isFavorite ? Colors.red : Colors.white,
          ),
          onPressed: () {
            setState(() {
              isFavorite = !isFavorite;
            });
          },
        ),
        IconButton(
          icon: Icon(
            Icons.share,
            color: Colors.white,
          ),
          onPressed: () {
            Share.share(title);
          },
        ),
      ],
    );
  }

  Column _buildDetailContent(DocumentSnapshot document) {
    return Column(
      children: <Widget>[
        SizedBox(
          child: MapHolder(
            targetName: document['location']['name'],
            targetLat: document['location']['lat'],
            targetLng: document['location']['lng'],
          ),
          height: 200,
        ),
      ],
    );
  }

  Container _buildAboutContent(DateTime date, DocumentSnapshot document) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 32,
              ),
              Icon(
                Icons.access_time,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                width: 24,
              ),
              Column(
                children: <Widget>[
                  Text(
                      '${date.day} / ${date.month} / ${(date.year.toInt() + 543)}'),
                  Text(
                      '${date.hour}:${date.minute < 10 ? '0' + date.minute.toString() : date.minute}')
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              )
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 32,
              ),
              Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                width: 24,
              ),
              //TODO: Create a method to get the string of status in long text format -> using document['attendeeStatus'] to check
              const Text('Status')
            ],
          ),
          SizedBox(
            height: 72,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  document['price'] == 0
                      ? 'FREE'
                      : document['price'].toString(),
                  style: TextStyle(
                    color: Colors.yellow[700],
                    fontSize: 24,
                  ),
                ),
              ),
              //TODO: Refactor this thing
              InkWell(
                onTap: () {},
                child: Container(
                  child: Center(
                    child: const Text(
                      "REGISTER",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  height: 68.00,
                  width: 177.00,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(15.00),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Row _buildDetailActive() {
    return Row(
      children: <Widget>[
        Container(
          height: 16.00,
          width: 16.00,
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        new Text(
          'Detail',
          style: TextStyle(
            fontSize: 15,
            color: Colors.deepPurple,
          ),
        ),
        SizedBox(
          width: 15,
        )
      ],
    );
  }

  Row _buildDetailInactive() {
    return Row(
      children: <Widget>[
        InkWell(
          child: Container(
            child: Text('Detail'),
          ),
          onTap: () {
            setState(() {
              isAboutOrDetail = !isAboutOrDetail;
            });
          },
        ),
        SizedBox(
          width: 25,
        )
      ],
    );
  }

  Row _buildAboutTabInactive() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 20,
        ),
        InkWell(
          child: Container(
            child: Text('About'),
          ),
          onTap: () {
            setState(() {
              isAboutOrDetail = !isAboutOrDetail;
            });
          },
        ),
      ],
    );
  }

  Row _buildAboutTabActive() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 15,
        ),
        Container(
          height: 16.00,
          width: 16.00,
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        new Text(
          'About',
          style: TextStyle(
            fontSize: 15,
            color: Colors.deepPurple,
          ),
        )
      ],
    );
  }
}
