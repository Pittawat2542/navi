import 'package:flutter/material.dart';

import 'package:Navi/widgets/HomeBottomNavigationBar.dart';
import 'package:Navi/screens/ActivityListScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Navi',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
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
          title: Text(widget.title),
          bottom: TabBar(
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
            ),
            labelColor: Colors.orangeAccent,
            unselectedLabelColor: Colors.white,
            tabs: tabBar
                .map(
                    (tab) => Tab(text: tab[0].toUpperCase() + tab.substring(1),),)
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
        bottomNavigationBar: HomeBottomNavigationBar(),
      ),
    );
  }
}
