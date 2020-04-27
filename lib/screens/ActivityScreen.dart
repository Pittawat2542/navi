import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share/share.dart';
import 'package:localstorage/localstorage.dart';

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
  final LocalStorage _storage = new LocalStorage('favorites');

  bool _isFavorite = false;
  bool _isAboutOrDetail = true;
  bool _isRegistered = false;

  @override
  Widget build(BuildContext context) {
    bool isFavoriteStorage = _storage.getItem(widget.activityId) == 'true' ? true : false;
    _isFavorite = isFavoriteStorage;

    if (widget.activityId != null) {
      return Scaffold(
        appBar: _buildAppBar(context, widget.title, widget.activityId),
        body: SingleChildScrollView(
          child: Stack(
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
                    var lastRegisterDate = new DateTime.fromMillisecondsSinceEpoch(
                        document['registrationEndDateTime'].seconds * 1000);
                    var startDate = new DateTime.fromMillisecondsSinceEpoch(
                        document['activityStartDateTime'].seconds * 1000);
                    var endDate = new DateTime.fromMillisecondsSinceEpoch(
                        document['activityEndDateTime'].seconds * 1000);
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
                            category: 'activity',
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            _isAboutOrDetail
                                ? _buildAboutTabActive()
                                : _buildAboutTabInactive(),
                            _isAboutOrDetail
                                ? _buildDetailTabInactive()
                                : _buildDetailTabActive()
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        _isAboutOrDetail
                            ? _buildAboutContent(lastRegisterDate, document)
                            : _buildDetailContent(startDate,endDate,document)
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text("No activity id!"),
        ),
      );
    }
  }

  String _generateAttendeeStatus(List attendeeStatus) {
    String result = '';
    attendeeStatus.forEach((status) {
      if (status.startsWith('grade')) {
        result += status[0].toUpperCase() + status.substring(1, 5) + ' ' + status.substring(5) + ', ';
      }
      if (status.startsWith('year')) {
        result += status[0].toUpperCase() + status.substring(1, 4) + ' ' + status.substring(4) + ', ';
      }
    });
    result = result.substring(0, result.length - 2);
    return result;
  }

  AppBar _buildAppBar(BuildContext context, String title, String activityId) {
    return AppBar(
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.favorite,
            color: _isFavorite ? Colors.deepPurple : Colors.white,
          ),
          onPressed: () {
            setState(() {
              _isFavorite = !_isFavorite;
              _storage.setItem(activityId, _isFavorite.toString());
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

  Column _buildDetailContent(
      DateTime startDate, DateTime endDate, DocumentSnapshot document) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Location : ${document['location']['name']}'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              'Time : ${startDate.day}/${startDate.month}/${(startDate.year.toInt() + 543)} ${startDate.hour}:${startDate.minute < 10 ? '0' + startDate.minute.toString() : startDate.minute} - ${endDate.day}/${endDate.month}/${(endDate.year.toInt() + 543)} ${endDate.hour}:${endDate.minute < 10 ? '0' + endDate.minute.toString() : endDate.minute}'),
        ),
        SizedBox(
          child: MapHolder(
              targetName: document['location']['name'],
              targetLat: document['location']['lat'],
              targetLng: document['location']['lng'],
              doc: document),
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
                      'Last Register date : ${date.day} / ${date.month} / ${(date.year.toInt() + 543)}'),
                  Text(
                      'Time : ${date.hour}:${date.minute < 10 ? '0' + date.minute.toString() : date.minute}')
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
              Text(_generateAttendeeStatus(document["attendeeStatus"]))
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
                    color: Colors.yellow[800],
                    fontSize: 24,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _isRegistered = !_isRegistered;
                  });
                },
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
                  height: MediaQuery.of(context).size.height / 15,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    color: _isRegistered ? Colors.grey : Theme.of(context).primaryColor,
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

  Row _buildDetailTabActive() {
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
            decoration: TextDecoration.underline,
          ),
        ),
        SizedBox(
          width: 15,
        )
      ],
    );
  }

  Row _buildDetailTabInactive() {
    return Row(
      children: <Widget>[
        InkWell(
          child: Container(
            child: Text('Detail'),
          ),
          onTap: () {
            setState(() {
              _isAboutOrDetail = !_isAboutOrDetail;
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
              _isAboutOrDetail = !_isAboutOrDetail;
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
            decoration: TextDecoration.underline,
          ),
        )
      ],
    );
  }
}
