import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:training_journal/Database_helper.dart';
import 'package:training_journal/Services/auth.dart';
import 'package:training_journal/Services/firestore_database.dart';
import 'package:training_journal/custom_widgets/Home_Page/session_card.dart';
import 'package:training_journal/custom_widgets/Home_Page/summary_stats_card.dart';
import 'package:training_journal/custom_widgets/Home_Page/upcoming.dart';
import 'package:training_journal/custom_widgets/Profile_Page/goal_card.dart';
import 'package:training_journal/event.dart';
import 'package:training_journal/pages/create_event.dart';
import 'package:training_journal/pages/create_session.dart';
import 'package:training_journal/pages/all_entries.dart';
import 'package:training_journal/pages/profile_page.dart';
import 'package:training_journal/pages/stats_page.dart';
import 'package:training_journal/stats_manager.dart';
import 'package:training_journal/training_session.dart';
import 'package:training_journal/user.dart';

class Home2 extends StatefulWidget {
  final DBHelper db;
  final User user;
  const Home2({
    @required this.db,
    @required this.user,
  });

  @override
  _Home2State createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  User userFS;
  User user;
  DatabaseService firestore;
  String appBarText;
  bool showStats;

  void initState() {
    appBarText = "Dashboard";
    showStats = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    userFS = Provider.of<User>(context);
    firestore = DatabaseService(uid: userFS.id);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: FutureBuilder<User>(
            future: firestore.getUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                user = snapshot.data;
              }
              return Scaffold(
                backgroundColor: Colors.grey[300],
                appBar: AppBar(
                  title: Text(
                    "$appBarText",
                    style: TextStyle(fontSize: 25),
                  ),
                  centerTitle: true,
                  elevation: 0,
                  backgroundColor: Colors.redAccent,
                  leading: IconButton(
                    icon: Icon(Icons.swap_vertical_circle),
                    iconSize: 30,
                    onPressed: () {
                      setState(() {
                        showStats = !showStats;
                      });
                    },
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.library_books),
                      iconSize: 30,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EntriesPage(
                                      db: widget.db,
                                      user: user,
                                    )));
                      },
                    ),
                  ],
                ),
                body: SafeArea(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      getTopPanel(),
                      getMiddleRow(),
                      getRecentSessions(),
                    ],
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endFloat,
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateSession(
                                  db: widget.db,
                                  user: user,
                                )));
                  },
                  child: Icon(Icons.add),
                  backgroundColor: Colors.redAccent,
                  elevation: 2,
                ),
                bottomNavigationBar: BottomNavigationBar(
                  selectedItemColor: Colors.redAccent,
                  currentIndex: 1,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.equalizer),
                      title: Text("Stats"),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      title: Text("Home"),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      title: Text("Profile"),
                    ),
                  ],
                  onTap: (index) async {
                    if (index == 2) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                    user: user,
                                  )));
                    } else if (index == 0) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StatsPage(
                                    user: user,
                                  )));
                    }
                  },
                ),
              );
            }),
      ),
    );
  }

  Widget getTopPanel() {
    if (showStats) {
    } else {
      return StreamBuilder<List<Event>>(
          stream: firestore.events,
          builder: (context, snapshot) {
            if (user == null) {
              return Container(
                height: 300,
                margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
              );
            }
            if (!snapshot.hasData) {
              return Container(
                height: 300,
                margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          "Your statistics/upcoming events will be displayed here\n"),
                      Text("Tap the swap icon above to switch views"),
                    ],
                  ),
                ),
              );
            }
            return Container(
              height: 300, // MediaQuery.of(context).size.height / 2.58,
              //width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.fromLTRB(10, 5, 0, 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Hero(
                      tag: 'UC$index',
                      child: UpcomingCard(
                        db: widget.db,
                        user: user,
                        event: snapshot.data[index],
                      ));
                },
              ),
            );
          });
    }
  }

  Widget getRecentSessions() {
    return StreamBuilder<List<TrainingSession>>(
        stream: firestore.recent,
        builder: (context, snapshot) {
          if (user == null) {
            return Container();
          }
          if (snapshot.data == null) {
            return Container(
              height: MediaQuery.of(context).size.height / 4,
              child: Center(
                child: Text("Tap the plus icon to create a session"),
              ),
            );
          }
          return Container(
            height: 250,
            margin: EdgeInsets.fromLTRB(0, 5, 0, 20),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Hero(
                    tag: 'SC$index',
                    child: SessionCard(
                      ts: snapshot.data[index],
                      db: widget.db,
                      user: user,
                    ));
              },
            ),
          );
        });
  }

  Widget getMiddleRow() {
    if (user == null) {
      return Container();
    }
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
            child: Text(
              "Recent Training Sessions",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.topRight,
            child: RaisedButton(
              color: Colors.redAccent,
              child: Text(
                "New Event",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateEvent(
                              db: widget.db,
                              user: user,
                            )));
              },
            ),
          ),
        ),
      ],
    );
  }
}
