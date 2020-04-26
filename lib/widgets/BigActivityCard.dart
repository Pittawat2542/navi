import 'package:Navi/screens/PlaceholderScreen.dart';
import 'package:flutter/material.dart';
import 'package:Navi/screens/ActivityScreen.dart';

class BigActivityCard extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  BigActivityCard(
      {@required this.id, @required this.title, @required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 16.0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
          topLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0)
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 228,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black54],
                    ),
                  ),
                  height: 64,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Positioned(
                left: 16.0,
                bottom: 16.0,
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
