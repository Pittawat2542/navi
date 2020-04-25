import 'package:flutter/material.dart';

class PlaceholderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Placeholder'),
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Text('Placeholder Screen'),
        ),
      ),
    );
  }
}
