import 'package:Navi/widgets/HomeBottomNavigationBar.dart';
import 'package:Navi/screens/ActivityListScreen.dart';
import 'package:Navi/screens/PlaceholderScreen.dart';
import 'package:flutter/material.dart';

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
      home: MyHomePage(title: 'KMUTT'),
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
  //TODO: Make tab dynamic -> using array
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
            tabs: <Widget>[
              Tab(text: 'News'),
              Tab(text: 'Activity'),
              Tab(text: 'Competition'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            PlaceholderScreen(),
            ActivityListScreen(),
            PlaceholderScreen(),
          ],
        ),
        bottomNavigationBar: HomeBottomNavigationBar(),
      ),
    );
  }
}
