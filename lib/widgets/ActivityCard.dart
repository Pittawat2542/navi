import 'package:flutter/material.dart';
import 'package:Navi/screens/ActivityDetailScreen.dart';

class ActivityCard extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final double height;
  final bool isActivityDetail;
  final bool isFavoriteCard;
  final String category;
  final String websiteUrl;

  ActivityCard(
      {@required this.id,
      @required this.title,
      @required this.imageUrl,
      @required this.websiteUrl,
      this.isActivityDetail = false,
      this.isFavoriteCard = false,
      this.height,
      @required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 16.0,
      ),
      child: InkWell(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
        ),
        onTap: () {
          !this.isActivityDetail
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ActivityDetailScreen(
                          id, title, category.toString(), websiteUrl)))
              : () {};
        },
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: this.height != null ? this.height : 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: isFavoriteCard
                        ? [
                            Chip(
                              label: Text(
                                category[0].toUpperCase() +
                                    category.substring(1),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: Colors.deepOrange,
                              padding: EdgeInsets.all(4),
                            ),
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: Colors.white,
                              ),
                            )
                          ]
                        : [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: Colors.white,
                              ),
                            ),
                          ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
