import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share/share.dart';
import 'package:localstorage/localstorage.dart';

import 'package:Navi/widgets/ActivityCard.dart';
import 'package:Navi/widgets/MapHolder.dart';

class ActivityDetailScreen extends StatefulWidget {
  final String activityId;
  final String category;
  final String title;

  ActivityDetailScreen(this.activityId, this.title, this.category);

  @override
  _ActivityDetailScreenState createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  final LocalStorage _storage = new LocalStorage('favorites');

  bool _isFavorite = false;
  bool _isAboutOrDetail = true;
  bool _isRegistered = false;

  @override
  Widget build(BuildContext context) {
    bool isFavoriteStorage =
        _storage.getItem(widget.activityId) == 'true' ? true : false;
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

                    DocumentSnapshot document = snapshot.data;
                    DateTime registrationStartDateTime =
                        new DateTime.fromMillisecondsSinceEpoch(
                            document['registrationStartDateTime'].seconds *
                                1000);
                    DateTime registrationEndDateTime =
                        new DateTime.fromMillisecondsSinceEpoch(
                            document['registrationEndDateTime'].seconds * 1000);
                    DateTime eventStartDateTime =
                        new DateTime.fromMillisecondsSinceEpoch(
                            document['activityStartDateTime'].seconds * 1000);
                    DateTime eventEndDateTime =
                        new DateTime.fromMillisecondsSinceEpoch(
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
                            ? _buildAboutContent(registrationStartDateTime,
                                registrationEndDateTime, document)
                            : _buildDetailContent(
                                eventStartDateTime, eventEndDateTime, document)
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
        result += status[0].toUpperCase() +
            status.substring(1, 5) +
            ' ' +
            status.substring(5) +
            ', ';
      }
      if (status.startsWith('year')) {
        result += status[0].toUpperCase() +
            status.substring(1, 4) +
            ' ' +
            status.substring(4) +
            ', ';
      }
    });
    result = result.substring(0, result.length - 2);
    return result;
  }

  String _getMonth(int monthNumber) {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[monthNumber - 1];
  }

  AppBar _buildAppBar(BuildContext context, String title, String activityId) {
    return AppBar(
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.favorite,
            color: _isFavorite ? Colors.lightBlueAccent : Colors.white,
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
        _buildContentRow(Icons.map, 'Location', document['location']['name']),
        _buildContentRow(Icons.access_time, 'Event Date/Time',
            '${startDate.day} ${_getMonth(startDate.month)} ${(startDate.year.toInt() + 543)} ${startDate.hour}:${startDate.minute < 10 ? '0' + startDate.minute.toString() : startDate.minute} - ${endDate.day} ${_getMonth(endDate.month)} ${(endDate.year.toInt() + 543)} ${endDate.hour}:${endDate.minute < 10 ? '0' + endDate.minute.toString() : endDate.minute}'),
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

  Container _buildAboutContent(
      DateTime startDate, DateTime endDate, DocumentSnapshot document) {
    return Container(
      child: Column(
        children: <Widget>[
          _buildContentRow(Icons.access_time, 'Registration period',
              '${startDate.day} ${_getMonth(startDate.month)} ${(startDate.year.toInt() + 543)} - ${endDate.day} ${_getMonth(endDate.month)} ${(endDate.year.toInt() + 543)}'),
          _buildContentRow(Icons.person, 'Participant Status',
              _generateAttendeeStatus(document["attendeeStatus"])),
          Divider(),
          SizedBox(
            height: MediaQuery.of(context).size.height / 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  document['price'] == 0
                      ? 'FREE'
                      : document['price'].toString() + ' ฿',
                  style: TextStyle(
                    color: document['price'] == 0
                        ? Colors.green
                        : Colors.grey[800],
                    fontSize: 24,
                    fontWeight: document['price'] == 0
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(16.0),
                onTap: () {
                  setState(() {
                    _isRegistered = !_isRegistered;
                  });
                },
                child: Container(
                  child: Center(
                    child: Text(
                      _isRegistered ? "REGISTERED" : "REGISTER",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height / 15,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    color: _isRegistered
                        ? Colors.grey
                        : Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Column _buildContentRow(IconData icon, String title, String content) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              width: 32,
            ),
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              width: 24,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12.0),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '${content}',
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 24,
        ),
      ],
    );
  }

  Row _buildDetailTabActive() {
    return Row(
      children: <Widget>[
        const Icon(
          Icons.assignment,
          color: Colors.deepOrange,
        ),
        const SizedBox(
          width: 8,
        ),
        const Text(
          'Detail',
          style: TextStyle(
            fontSize: 16,
            color: Colors.deepOrange,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          width: 16,
        )
      ],
    );
  }

  Row _buildDetailTabInactive() {
    return Row(
      children: <Widget>[
        const Icon(
          Icons.assignment,
          color: Colors.black87,
        ),
        SizedBox(
          width: 8,
        ),
        InkWell(
          child: Container(
            child: const Text('Detail'),
          ),
          onTap: () {
            setState(() {
              _isAboutOrDetail = !_isAboutOrDetail;
            });
          },
        ),
        SizedBox(
          width: 24,
        )
      ],
    );
  }

  Row _buildAboutTabInactive() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 16,
        ),
        Icon(
          Icons.info,
          color: Colors.black87,
        ),
        SizedBox(
          width: 8,
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
          width: 16,
        ),
        Icon(
          Icons.info,
          color: Colors.deepOrange,
        ),
        SizedBox(
          width: 8,
        ),
        new Text(
          'About',
          style: TextStyle(
            fontSize: 16,
            color: Colors.deepOrange,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
