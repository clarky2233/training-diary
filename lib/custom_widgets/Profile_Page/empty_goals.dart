import 'package:flutter/material.dart';
import 'package:training_journal/Database_helper.dart';
import 'package:training_journal/event.dart';
import 'package:training_journal/pages/home.dart';
import 'package:training_journal/pages/profile_page.dart';
import 'package:training_journal/training_session.dart';
import 'package:training_journal/user.dart';

class EmptyGoals extends StatefulWidget {
  final DBHelper db;
  final User user;
  final List<Goal> goals;
  const EmptyGoals({this.db, this.user, this.goals});

  @override
  _EmptyGoalsState createState() => _EmptyGoalsState();
}

class _EmptyGoalsState extends State<EmptyGoals> {
  bool isValid(Goal goal) {
    if (goal.text == null || goal.title == null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.black,
              onPressed: () {},
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
              Expanded(
                  child: Center(
                      child: Text("Tap the plus icon to create a goal"))),
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
              icon: Icon(Icons.assessment),
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
            }
          },
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
                                      user: widget.user,
                                    )));
                      } else {
                        Navigator.pop(context);
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
}
