import 'dart:math';

import 'package:Navi/widgets/MapHolder.dart';
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
              onTap: () {
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
                    var date = new DateTime.fromMillisecondsSinceEpoch(
                        document['activityStartDateTime'].seconds * 1000);
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
                                    new Text(
                                      "About",
                                      style: TextStyle(
                                        fontFamily: "Segoe UI",
                                        fontSize: 15,
                                        color: Color(0xff5c5ed8),
                                      ),
                                    )
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
                                    new Text(
                                      "Detail",
                                      style: TextStyle(
                                        fontFamily: "Segoe UI",
                                        fontSize: 15,
                                        color: Color(0xff5c5ed8),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    )
                                  ],
                                )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      widget.isAboutOrDetail
                          ? Container(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 32,
                                      ),
                                      Image(
                                        image: AssetImage(
                                            'images/activity/time.png'),
                                        height: 24,
                                        width: 24,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                        size: 24,
                                        color: Color(0xFFFF8B51),
                                      ),
                                      SizedBox(
                                        width: 24,
                                      ),
                                      Text('Staus')
                                    ],
                                  ),
                                  SizedBox(
                                    height: 72,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24),
                                        child: Text(
                                          'Free',
                                          style: TextStyle(
                                              color: Color(0xFFD8BC5C),
                                              fontSize: 24),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: new Container(
                                          child: Center(
                                            child: new Text(
                                              "REGISTER!!",
                                              style: TextStyle(
                                                fontFamily: "Segoe UI",
                                                fontSize: 20,
                                                color: Color(0xffffffff),
                                              ),
                                            ),
                                          ),
                                          height: 68.00,
                                          width: 177.00,
                                          decoration: BoxDecoration(
                                            color: Color(0xffff8b51),
                                            borderRadius:
                                                BorderRadius.circular(15.00),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          : Column(
                              children: <Widget>[
                                SizedBox(
                                  child: MapHolder(
                                      document['location']['lat'],
                                      document['location']['lng'],
                                      document['location']['name']
                                  ),
                                  height: 200,
                                ),
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
