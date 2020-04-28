import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:Navi/models/Message.dart';

class MessagingList extends StatefulWidget {
  @override
  _MessagingListState createState() => _MessagingListState();
}

class _MessagingListState extends State<MessagingList> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          messages.add(Message(
              title: notification['title'], body: notification['body']));
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        final notification = message['data'];
        setState(() {
          messages.add(Message(
            title: '${notification['title']}',
            body: '${notification['body']}',
          ));
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: messages.length == 0
          ? Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.notifications_off,
                    size: 64.0,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  const Text(
                    "No notifications",
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                ],
              ),
          )
          : ListView(
              children: messages.map(buildMessage).toList(),
            ),
    );
  }

  Widget buildMessage(Message message) => Column(
        children: <Widget>[
          ListTile(
            title: Text(message.title),
            subtitle: Text(message.body),
          ),
          Divider()
        ],
      );
}
