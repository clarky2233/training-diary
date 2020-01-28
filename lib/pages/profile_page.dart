import 'package:flutter/material.dart';
import 'package:training_journal/Database_helper.dart';
import 'package:training_journal/custom_widgets/Profile_Page/goal_card.dart';
import 'package:training_journal/event.dart';
import 'package:training_journal/pages/edit_profile.dart';
import 'package:training_journal/pages/home.dart';
import 'package:training_journal/pages/stats_page.dart';
import 'package:training_journal/stats_manager.dart';
import 'package:training_journal/training_session.dart';
import 'package:training_journal/user.dart';

class ProfilePage extends StatefulWidget {
  final DBHelper db;
  final User user;
  final List<Goal> goals;
  const ProfilePage(
      {@required this.db, @required this.user, @required this.goals});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int size = 0;

  void initState() {
    super.initState();
    if (widget.goals != null) {
      size = widget.goals.length;
    }
  }

  bool isValid(Goal goal) {
    if (goal.text == null ||
        goal.title == null ||
        goal.text == "" ||
        goal.title == "") {
      return false;
    } else {
      return true;
    }
  }

  double getAge() {
    DateTime dob = widget.user.dob;
    double diff = DateTime.now().difference(dob).inDays / 365.floor();
    return diff;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: Colors.grey[300],
          appBar: AppBar(
            backgroundColor: Colors.grey[300],
            elevation: 0,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                color: Colors.black,
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfile(
                                db: widget.db,
                                user: widget.user,
                              )));
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                    "${widget.user.name}",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "(${widget.user.username})",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Center(
                //   child: Text(
                //     "${getAge().floor()} years old",
                //     style: TextStyle(
                //       fontSize: 20,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 30, 0, 0),
                  child: Text(
                    "My Goals",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                getPanel(),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              createGoal();
            },
            icon: Icon(Icons.add),
            label: Text("New Goal"),
            backgroundColor: Colors.red[600],
            elevation: 2,
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.red[600],
            currentIndex: 2,
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
              if (index == 1) {
                List<TrainingSession> x = await widget.db.lastTenSessions();
                List<Event> upcoming = await widget.db.getEvents();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home(
                              recentTen: x,
                              db: widget.db,
                              user: widget.user,
                              upcoming: upcoming,
                            )));
              } else if (index == 0) {
                StatsManager sm = StatsManager(dbhelper: widget.db);
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

  Future<void> createGoal() async {
    String goalValue;
    String titleStr;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            'New Goal',
            style: TextStyle(fontSize: 26),
          ),
          contentPadding: EdgeInsets.all(5),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                maxLines: 1,
                cursorColor: Colors.pink[400],
                //controller: textController,
                onChanged: (text) {
                  setState(() {
                    titleStr = text;
                  });
                },
                style: TextStyle(
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                    hintText: "Title",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.redAccent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.redAccent),
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                maxLines: 10,
                cursorColor: Colors.redAccent[400],
                //controller: textController,
                onChanged: (text) {
                  setState(() {
                    goalValue = text;
                  });
                },
                style: TextStyle(
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                    hintText: "Description",
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent[400])),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent[400]))),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: FlatButton(
                    onPressed: () async {
                      Goal goal = new Goal(
                          userID: widget.user.id,
                          text: goalValue,
                          title: titleStr);
                      if (isValid(goal)) {
                        await widget.db.insertGoal(goal);
                        List<Goal> goals = await widget.db.getGoals();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                      db: widget.db,
                                      user: widget.user,
                                      goals: goals,
                                    )));
                      } else {
                        _neverSatisfied();
                      }
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "CANCEL",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _neverSatisfied() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Incomplete Data'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please complete all available fields.'),
                Text('The Description field is optional.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Ok',
                style: TextStyle(color: Colors.pink[800]),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget getPanel() {
    if (size == 0) {
      return Expanded(
          child: Center(child: Text("Tap the plus icon to create a goal")));
    } else {
      return Expanded(
        child: Container(
          //margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: ListView.builder(
            itemCount: size,
            itemBuilder: (context, index) {
              return Hero(
                  tag: 'GC$index',
                  child: GoalCard(
                    db: widget.db,
                    user: widget.user,
                    goal: widget.goals[index],
                  ));
            },
          ),
        ),
      );
    }
  }
}
