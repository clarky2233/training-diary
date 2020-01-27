import 'package:flutter/material.dart';
import 'package:training_journal/Services/firestore_database.dart';
import 'package:training_journal/custom_widgets/Create_Event/event_date_card.dart';
import 'package:training_journal/custom_widgets/Create_Event/event_time_card.dart';
import 'package:training_journal/custom_widgets/Create_Event/event_title_card.dart';
import 'package:training_journal/Database_helper.dart';
import 'package:training_journal/event.dart';
import 'package:training_journal/pages/home.dart';
import 'package:training_journal/pages/home_2.dart';
import 'package:training_journal/training_session.dart';
import 'package:training_journal/user.dart';

class CreateEvent extends StatefulWidget {
  final DBHelper db;
  final User user;
  const CreateEvent({@required this.db, @required this.user});

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent>
    with SingleTickerProviderStateMixin {
  Event event = Event();
  DatabaseService firestore;

  void initState() {
    firestore = DatabaseService(uid: widget.user.id);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isValid(Event event) {
    if (event.name == null || event.date == null || event.startTime == null) {
      return false;
    } else {
      return true;
    }
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
            title: Text('New Upcoming Event'),
            centerTitle: true,
            backgroundColor: Colors.redAccent,
            leading: FlatButton(
              onPressed: () async {
                FocusScope.of(context).requestFocus(new FocusNode());
                Navigator.pop(context);
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => Home2(
                //               db: widget.db,
                //               user: widget.user,
                //             )));
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  EventTitleCard(
                    event: event,
                    isEdit: false,
                  ),
                  EventDateCard(
                    event: event,
                    isEdit: false,
                  ),
                  EventTimeCard(
                    event: event,
                    isEdit: false,
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (isValid(event)) {
                FocusScope.of(context).requestFocus(new FocusNode());
                event.userID = widget.user.id;
                firestore.updateEvent(event);
                Navigator.pop(context);
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => Home2(
                //               db: widget.db,
                //               user: widget.user,
                //             )));
              } else {
                _neverSatisfied();
              }
            },
            child: Icon(Icons.done_outline),
            backgroundColor: Colors.redAccent,
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
                style: TextStyle(color: Colors.redAccent),
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
