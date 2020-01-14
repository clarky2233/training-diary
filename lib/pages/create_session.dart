import 'package:flutter/material.dart';
import 'package:training_journal/custom_widgets/Advanced_Settings/advanced_session_setttings.dart';
import 'package:training_journal/custom_widgets/Standard_Settings/standard_session_settings.dart';
import 'package:training_journal/Database_helper.dart';
import 'package:training_journal/event.dart';
import 'package:training_journal/pages/home.dart';
import 'package:training_journal/pages/templates.dart';
import 'package:training_journal/training_session.dart';
import 'package:training_journal/user.dart';

class CreateSession extends StatefulWidget {

  final DBHelper db;
  final User user;
  const CreateSession({@required this.db, @required this.user,});

  @override
  _CreateSessionState createState() => _CreateSessionState();
}

class _CreateSessionState extends State<CreateSession> with SingleTickerProviderStateMixin {
  TrainingSession ts = TrainingSession();
  TabController tabController;

  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WillPopScope(
        onWillPop: () {return Future.value(false);},
        child: Scaffold(
          backgroundColor: Colors.grey[400],
          appBar: AppBar(
            title: Text('New Training Session'),
            centerTitle: true,
            backgroundColor: Colors.pink[500],
            leading: FlatButton(
              onPressed: () async {
                FocusScope.of(context).requestFocus(new FocusNode());
                List<TrainingSession> x = await widget.db.lastTenSessions();
                List<Event> upcoming = await widget.db.getEvents();
                Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                  builder: (context) => Home(db: widget.db, user: widget.user, recentTen: x, upcoming: upcoming,)
                )
              );
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.save),
                onPressed: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                    List<TrainingSession> x = await widget.db.getTemplates();
                    Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => TemplatePage(db: widget.db, user: widget.user, templates: x,)
                    )
                  );
                },
              ),
            ],
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
              StandardSessionSettings(db: widget.db, user: widget.user, ts: ts, isEdit: false,),
              AdvancedSessionSettings(db: widget.db, user: widget.user, ts: ts, isEdit: false,),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (TrainingSession.isValid(ts)) {
                ts.userID = widget.user.id;
                await widget.db.insertSession(ts);
                List<TrainingSession> x = await widget.db.lastTenSessions();
                 List<Event> upcoming = await widget.db.getEvents();
                Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                  builder: (context) => Home(db: widget.db, user: widget.user, recentTen: x, upcoming: upcoming,)
                )
              );
                //print(await widget.db.getJournal());
              }
              else {
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
              Text('The Description field is optional.'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok', style: TextStyle(color: Colors.pink[800]),),
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