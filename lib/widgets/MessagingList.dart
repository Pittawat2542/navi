import 'package:flutter/material.dart';
import 'package:Navi/models/Message.dart';

class MessagingList extends StatefulWidget {
  final List<MessageNotification> messages;
  MessagingList(this.messages);
  @override
  _MessagingListState createState() => _MessagingListState(this.messages);
}

class _MessagingListState extends State<MessagingList> {
  final List<MessageNotification> messages;
  _MessagingListState(this.messages);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: (messages.length == 0 || messages == null)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.notifications_off,
                    size: 64.0,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  const Text(
                    'No notifications',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  const Text(
                      'Notifications will appear while using application.')
                ],
              ),
            )
          : ListView(
              children: messages.map(buildMessage).toList(),
            ),
    );
  }

  Widget buildMessage(MessageNotification message) => Column(
        children: <Widget>[
          ListTile(
            title: Text(message.title),
            subtitle: Text(message.body),
          ),
          Divider()
        ],
      );
}
