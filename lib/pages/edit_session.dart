import 'package:flutter/material.dart';
import 'package:training_journal/Services/firestore_database.dart';
import 'package:training_journal/custom_widgets/Advanced_Settings/advanced_session_setttings.dart';
import 'package:training_journal/custom_widgets/Standard_Settings/standard_session_settings.dart';
import 'package:training_journal/Database_helper.dart';
import 'package:training_journal/event.dart';
import 'package:training_journal/pages/all_entries.dart';
import 'package:training_journal/pages/home.dart';
import 'package:training_journal/pages/home_2.dart';
import 'package:training_journal/training_session.dart';
import 'package:training_journal/user.dart';

class EditSession extends StatefulWidget {
  final DBHelper db;
  final User user;
  final TrainingSession ts;
  final bool returnHome;
  const EditSession(
      {@required this.db,
      @required this.user,
      @required this.ts,
      @required this.returnHome});

  @override
  _EditSessionState createState() => _EditSessionState();
}

class _EditSessionState extends State<EditSession>
    with SingleTickerProviderStateMixin {
  TrainingSession original;

  TabController tabController;

  DatabaseService firestore;

  void initState() {
    tabController = TabController(length: 2, vsync: this);
    original = deepCopy(widget.ts);
    firestore = DatabaseService(uid: widget.user.id);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  TrainingSession deepCopy(TrainingSession ts) {
    TrainingSession original = TrainingSession();
    original.id = ts.id;
    original.userID = ts.userID;
    original.title = ts.title;
    original.duration = ts.duration;
    original.description = ts.description;
    original.activity = ts.activity;
    original.difficulty = ts.difficulty;
    original.date = ts.date;
    original.heartRate = ts.heartRate;
    original.rpe = ts.rpe;
    original.hoursOfSleep = ts.hoursOfSleep;
    original.sleepRating = ts.sleepRating;
    return original;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: Colors.grey[400],
          appBar: AppBar(
            title: Text('Edit Training Session'),
            centerTitle: true,
            backgroundColor: Colors.pink[500],
            leading: FlatButton(
              onPressed: () async {
                FocusScope.of(context).requestFocus(new FocusNode());
                //await widget.db.updateJournalEntry(original);
                // List<TrainingSession> x = await widget.db.lastTenSessions();
                // List<TrainingSession> y = await widget.db.getJournal();
                // List<Event> upcoming = await widget.db.getEvents();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  if (widget.returnHome) {
                    return Home2(
                      db: widget.db,
                      user: widget.user,
                      recentTen: null,
                      upcoming: null,
                    );
                  } else {
                    return EntriesPage(
                      db: widget.db,
                      user: widget.user,
                      allEntries: null,
                    );
                  }
                }));
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            bottom: TabBar(
              indicatorColor: Colors.white,
              controller: tabController,
              tabs: <Widget>[
                Tab(
                  text: "Standard",
                ),
                Tab(
                  text: "Advanced",
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: <Widget>[
              StandardSessionSettings(
                db: widget.db,
                user: widget.user,
                ts: widget.ts,
                isEdit: true,
              ),
              AdvancedSessionSettings(
                db: widget.db,
                user: widget.user,
                ts: widget.ts,
                isEdit: true,
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (TrainingSession.isValid(widget.ts)) {
                FocusScope.of(context).requestFocus(new FocusNode());
                widget.ts.userID = widget.user.id;
                firestore.updateTrainingSession(widget.ts);
                // await widget.db.updateJournalEntry(widget.ts);
                // List<TrainingSession> x = await widget.db.lastTenSessions();
                // List<TrainingSession> y = await widget.db.getJournal();
                // List<Event> upcoming = await widget.db.getEvents();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  if (widget.returnHome) {
                    return Home(
                      db: widget.db,
                      user: widget.user,
                      recentTen: null,
                      upcoming: null,
                    );
                  } else {
                    return EntriesPage(
                      db: widget.db,
                      user: widget.user,
                      allEntries: null,
                    );
                  }
                }));
              } else {
                _neverSatisfied();
              }
            },
            child: Icon(Icons.done_outline),
            backgroundColor: Colors.pink[600],
          ),
        ),
      ),
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
}
