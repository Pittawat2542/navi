import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:Navi/widgets/BigActivityCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityScreen extends StatefulWidget {
  final String activityId;
  bool iSfavorite = false;
  bool isAboutOrDetail = true;

  ActivityScreen(this.activityId);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.activityId != null) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFEEEEEE),
            leading: InkWell(
              child: Transform.rotate(
                angle: pi,
                child: Icon(
                  Icons.play_arrow,
                  color: Color(0xFF50E076),
                  size: 36,
                ),
              ),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              RawMaterialButton(
                onPressed: () {
                  setState(() {
                    widget.iSfavorite = !widget.iSfavorite;
                    print(widget.iSfavorite);
                  });
                },
                child: widget.iSfavorite
                    ? Image(
                        image: AssetImage('images/activity/heart.png'),
                        fit: BoxFit.cover,
                        height: 24,
                        width: 24,
                      )
                    : Icon(
                        Icons.favorite,
                        color: Colors.black,
                        size: 24,
                      ),
              ),
              RawMaterialButton(
                onPressed: () {
                  setState(() {
                    print('share');
                  });
                },
                child: Image(
                  image: AssetImage('images/activity/share.png'),
                  fit: BoxFit.cover,
                  height: 24,
                  width: 24,
                ),
              )
            ],
          ),
          body: Stack(
            children: <Widget>[
              Container(
                color: Color(0xFFEEEEEE),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: Firestore.instance
                      .collection('activity')
                      .document(widget.activityId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return new Text("Loading");
                    }
                    var document = snapshot.data;
                    return Column(children: [
                      BigActivityCard(
                        id: document.documentID,
                        title: document["title"],
                        imageUrl: document["imageUrl"],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          widget.isAboutOrDetail
                              ? Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      height: 16.00,
                                      width: 16.00,
                                      decoration: BoxDecoration(
                                        color: Color(0xff5c5ed8),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('About')
                                  ],
                                )
                              : Row(
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
                                          widget.isAboutOrDetail =
                                              !widget.isAboutOrDetail;
                                        });
                                      },
                                    ),
                                ],
                              ),
                          widget.isAboutOrDetail
                              ? Row(
                                children: <Widget>[
                                  InkWell(
                                      child: Container(
                                        child: Text('Detail'),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          widget.isAboutOrDetail =
                                              !widget.isAboutOrDetail;
                                        });
                                      },
                                    ),
                                  SizedBox(
                                    width: 25,
                                  )
                                ],
                              )
                              : Row(
                                  children: <Widget>[
                                    Container(
                                      height: 16.00,
                                      width: 16.00,
                                      decoration: BoxDecoration(
                                        color: Color(0xff5c5ed8),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('Detail'),
                                    SizedBox(
                                      width: 15,
                                    )
                                  ],
                                )
                        ],
                      )
                    ]);
                  },
                ),
              )
            ],
          ));
    }
  }
}
