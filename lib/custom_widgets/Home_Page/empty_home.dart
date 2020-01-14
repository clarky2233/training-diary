import 'package:flutter/material.dart';
import 'package:training_journal/Database_helper.dart';
import 'package:training_journal/pages/create_session.dart';
import 'package:training_journal/pages/profile_page.dart';
import 'package:training_journal/training_session.dart';
import 'package:training_journal/user.dart';

class EmptyHome extends StatefulWidget {

  final DBHelper db;
  final User user;
  final List<TrainingSession> recentTen;
  const EmptyHome({this.db, this.user, this.recentTen});
  
  @override
  _EmptyHomeState createState() => _EmptyHomeState();
}

class _EmptyHomeState extends State<EmptyHome> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WillPopScope(
        onWillPop: () {return Future.value(false);},
        child: Scaffold(
          backgroundColor: Colors.grey[300],
          body: Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
                  child: Text(
                    "Your Statistics",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                Container(
                  height: 250,
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 20),
                  child: Center(child: Text("  Your statistics will be displayed here.\n\nCreate a training session to get started!"))
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Text(
                    "Recent Training Sessions",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  height: 250,
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 20),
                  child: Center(child: Text("Tap the plus icon to create a training session"))
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
                  builder: (context) => CreateSession(db: widget.db, user: widget.user,)
                )
              );
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.red[600],
            elevation: 2,
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.red[600],
            currentIndex: 1,
            items: <BottomNavigationBarItem> [
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
              if (index == 2) {
                List<Goal> goals = await widget.db.getGoals();
                Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                  builder: (context) => ProfilePage(db: widget.db, user: widget.user, goals: goals,)
                )
              );
              }
            },
          ),
        ),
      ),
    );
  }
}