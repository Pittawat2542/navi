import 'package:Navi/widgets/SolidIndicator.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        //TODO Change appbar color to orange
        primarySwatch: Colors.blue,
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
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFF8B51),
          title: Text(widget.title),
          bottom: TabBar(
            indicator: SolidIndicator(),
            labelColor: Color(0xFFFF8B51),
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
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     showSearch(
        //       context: context,
        //       delegate: AppSearchDelegate(),
        //     );
        //   },
        //   child: Icon(Icons.search),
        // ),
        bottomNavigationBar: HomeBottomNavigationBar(),
      ),
    );
  }
}
