import 'package:Navi/screens/AppSearchDelegate.dart';
import 'package:Navi/screens/FavoriteScreen.dart';
import 'package:flutter/material.dart';

class HomeBottomNavigationBar extends StatefulWidget {
  const HomeBottomNavigationBar({Key key}) : super(key: key);

  @override
  _HomeBottomNavigationBarState createState() =>
      _HomeBottomNavigationBarState();
}

//TODO: Align text and icon side by side
class _HomeBottomNavigationBarState extends State<HomeBottomNavigationBar> {
  int _currentIndex = 0;

  Material _bottomNavigationBarItem(
      int itemIndex, IconData icon, String text, Function() action) {
    return Material(
      color:
          _currentIndex == itemIndex ? Colors.orangeAccent : Colors.transparent,
      borderRadius: BorderRadius.circular(30.0),
      child: InkWell(
        customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        onTap: () => {
          setState(() => {_currentIndex = itemIndex}),
          action()
        },
        child: Container(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          height: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: Colors.black, size: 30),
              Offstage(
                offstage: _currentIndex == itemIndex ? false : true,
                child: Text(text, style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _bottomNavigationBarItem(
              0,
              Icons.bookmark,
              "Save",
              () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => FavoriteScreen()))),
          _bottomNavigationBarItem(
              1,
              Icons.search,
              "Explore",
              () =>
                  showSearch(context: context, delegate: AppSearchDelegate())),
        ],
      ),
    );
  }
}
