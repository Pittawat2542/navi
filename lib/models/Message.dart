import 'package:flutter/material.dart';

@immutable
class MessageNotification {
  final String title;
  final String body;

  const MessageNotification({
    @required this.title,
    @required this.body,
  });
}