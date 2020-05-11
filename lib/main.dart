import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:Navi/models/Message.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<MessageNotification> messages = [];


  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          showNotification(notification['title'], notification['body']);
          messages.add(MessageNotification(
              title: notification['title'], body: notification['body']));
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        final notification = message['data'];
        setState(() {
          showNotification(notification['title'], notification['body']);
          messages.add(MessageNotification(
            title: '${notification['title']}',
            body: '${notification['body']}',
          ));
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }


  showNotification(title, body) async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High,importance: Importance.Max
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, 'Navi', title.toString(), platform,
        payload: body.toString());
  }


  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ),
    );
  }

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
                    MaterialPageRoute(builder: (context) => MessagingList(messages)));
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
