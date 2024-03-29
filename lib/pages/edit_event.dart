import 'package:flutter/material.dart';
import 'package:training_journal/Services/firestore_database.dart';
import 'package:training_journal/custom_widgets/Create_Event/event_date_card.dart';
import 'package:training_journal/custom_widgets/Create_Event/event_time_card.dart';
import 'package:training_journal/custom_widgets/Create_Event/event_title_card.dart';
import 'package:training_journal/event.dart';
import 'package:training_journal/user.dart';

class EditEvent extends StatefulWidget {
  final User user;
  final Event event;
  const EditEvent({@required this.user, @required this.event});

  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent>
    with SingleTickerProviderStateMixin {
  Event original;
  DatabaseService firestore;

  void initState() {
    original = deepCopy(widget.event);
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

  Event deepCopy(Event event) {
    Event original = Event();
    original.id = event.id;
    original.userID = event.userID;
    original.name = event.name;
    original.date = event.date;
    original.startTime = event.startTime;
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
            title: Text('Edit Upcoming Event'),
            centerTitle: true,
            backgroundColor: Colors.redAccent,
            leading: FlatButton(
              onPressed: () async {
                FocusScope.of(context).requestFocus(new FocusNode());
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                EventTitleCard(
                  event: widget.event,
                  isEdit: true,
                ),
                EventDateCard(
                  event: widget.event,
                  isEdit: true,
                ),
                EventTimeCard(
                  event: widget.event,
                  isEdit: true,
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (isValid(widget.event)) {
                widget.event.userID = widget.user.id;
                firestore.updateEvent(widget.event);
                Navigator.pop(context);
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
