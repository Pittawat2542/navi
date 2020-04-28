import 'package:flutter/material.dart';

import 'package:Navi/screens/AppSearchDelegate.dart';
import 'package:Navi/screens/ActivityListScreen.dart';
import 'package:Navi/screens/FavoriteScreen.dart';
import 'package:Navi/screens/SettingsScreen.dart';
import 'package:Navi/widgets/HomeBottomNavigationBar.dart';
import 'package:Navi/widgets/MessagingList.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Navi',
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
        textTheme: TextTheme(

        )
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.deepOrange
      ),
      home: MyHomePage(title: 'Navi'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final tabBar = ['news', 'activity', 'competition'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.notifications_active),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MessagingList()));
              },
            ),
          ],
          title: Text(widget.title),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: tabBar
                .map(
                  (tab) => Tab(
                    text: tab[0].toUpperCase() + tab.substring(1),
                  ),
                )
                .toList(),
          ),
        ),
        body: TabBarView(
          children: tabBar
              .map(
                (tab) => ActivityListScreen(
                  category: tab,
                ),
              )
              .toList(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () =>
              showSearch(context: context, delegate: AppSearchDelegate()),
          tooltip: 'Search',
          child: Icon(Icons.search),
          elevation: 4.0,
        ),
        bottomNavigationBar: HomeBottomNavigationBar(
          notchedShape: CircularNotchedRectangle(),
          items: [
            HomeBottomNavigationBarItem(
                icon: Icons.favorite,
                text: 'Favorites',
                action: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FavoriteScreen()))),
            HomeBottomNavigationBarItem(
                icon: Icons.settings,
                text: 'Settings',
                action: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingsScreen()))),
          ],
        ),
      ),
    );
  }
}
