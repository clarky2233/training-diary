import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:training_journal/Database_helper.dart';
import 'package:training_journal/Services/auth.dart';
import 'package:training_journal/custom_widgets/Home_Page/session_card.dart';
import 'package:training_journal/custom_widgets/Home_Page/summary_stats_card.dart';
import 'package:training_journal/custom_widgets/Home_Page/upcoming.dart';
import 'package:training_journal/event.dart';
import 'package:training_journal/pages/create_event.dart';
import 'package:training_journal/pages/create_session.dart';
import 'package:training_journal/pages/all_entries.dart';
import 'package:training_journal/pages/profile_page.dart';
import 'package:training_journal/pages/stats_page.dart';
import 'package:training_journal/stats_manager.dart';
import 'package:training_journal/training_session.dart';
import 'package:training_journal/user.dart';

class Home extends StatefulWidget {
  final DBHelper db;
  final User user;
  final List<TrainingSession> recentTen;
  final List<Event> upcoming;
  const Home(
      {@required this.db,
      @required this.user,
      @required this.recentTen,
      @required this.upcoming});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  void initState() {
    super.initState();
    if (widget.recentTen != null) {
      trainingsize = widget.recentTen.length;
      upcomingSize = widget.upcoming.length;
      if (trainingsize == 0 && upcomingSize == 0) {
        showDashboard = true;
      } else {
        showDashboard = false;
      }
      if (trainingsize > 0) {
        showStats = true;
      }
    }
    if (widget.upcoming != null) {
      eventSize = widget.upcoming.length;
    }
    titleText = getTopText();
    sm = StatsManager(dbhelper: widget.db);
  }

  int trainingsize = 0;
  int upcomingSize = 0;
  String titleText;
  int eventSize = 0;
  StatsManager sm;
  bool showDashboard = true;
  bool showStats = false;

  Future<List<TrainingSession>> getRecent() async {
    return await widget.db.lastTenSessions();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    titleText = getTopText();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: Colors.grey[300],
          body: SafeArea(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: getTopRow()),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: getHomePanel(),
                ),
                Row(
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
                          color: Colors.red[400],
                          child: Text(
                            "New Event",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateEvent(
                                          db: widget.db,
                                          user: widget.user,
                                        )));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: getBottomPanel(),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateSession(
                            db: widget.db,
                            user: widget.user,
                          )));
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.red[600],
            elevation: 2,
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.red[600],
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
                List<Goal> goals = await widget.db.getGoals();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(
                              db: widget.db,
                              user: widget.user,
                              goals: goals,
                            )));
              } else if (index == 0) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StatsPage(
                              sm: sm,
                              user: widget.user,
                              db: widget.db,
                            )));
              }
            },
          ),
        ),
      ),
    );
  }

  String getTopText() {
    if (showDashboard) {
      return "DashBoard";
    } else if (showStats) {
      return "Statistics";
    } else {
      return "Upcoming";
    }
  }

  Widget getTopRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          "$titleText",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        getSwapIcon(),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 15, 5),
              child: IconButton(
                icon: Icon(
                  Icons.library_books,
                  size: 30,
                ),
                onPressed: () async {
                  await _auth.signOut();
                  // List<TrainingSession> x = await widget.db.getJournal();
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => EntriesPage(
                  //               db: widget.db,
                  //               user: widget.user,
                  //               allEntries: x,
                  //             )));
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getSwapIcon() {
    if (showDashboard) {
      return SizedBox();
    } else {
      return IconButton(
        icon: Icon(Icons.swap_vert),
        iconSize: 30,
        onPressed: () {
          setState(() {
            showDashboard = false;
            showStats = !showStats;
          });
        },
      );
    }
  }

  Widget getHomePanel() {
    if (showDashboard) {
      return Container(
          height: 250,
          margin: EdgeInsets.fromLTRB(0, 5, 0, 20),
          child: Center(
              child: Text(
                  "  Your statistics/upcoming events will be displayed here.")));
    } else if (showStats) {
      return Container(
        height: 300, //MediaQuery.of(context).size.height / 2.58,
        margin: EdgeInsets.fromLTRB(10, 5, 0, 10),
        child: SummaryStatsCard(
          sm: sm,
          title: "Duration (blue) and Intensity / 5 (red)",
        ),
      );
    } else {
      return Container(
        height: 300, // MediaQuery.of(context).size.height / 2.58,
        //width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(10, 5, 0, 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: upcomingSize,
          itemBuilder: (context, index) {
            return Hero(
                tag: 'UC$index',
                child: UpcomingCard(
                  db: widget.db,
                  user: widget.user,
                  event: widget.upcoming[index],
                ));
          },
        ),
      );
    }
  }

  Widget getBottomPanel() {
    if (widget.recentTen == null || widget.recentTen.length == 0) {
      return Container(
          height: 250,
          margin: EdgeInsets.fromLTRB(0, 5, 0, 20),
          child: Center(
              child: Text("Tap the plus icon to create a training session")));
    } else {
      return Container(
        height: 250,
        margin: EdgeInsets.fromLTRB(0, 5, 0, 20),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: trainingsize,
          itemBuilder: (context, index) {
            return Hero(
                tag: 'SC$index',
                child: SessionCard(
                  ts: widget.recentTen[index],
                  db: widget.db,
                  user: widget.user,
                ));
          },
        ),
      );
    }
  }
}
