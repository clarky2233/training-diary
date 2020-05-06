import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:training_journal/Database_helper.dart';
import 'package:training_journal/Services/firestore_database.dart';
import 'package:training_journal/event.dart';
import 'package:training_journal/pages/edit_event.dart';
import 'package:training_journal/pages/home_2.dart';
import 'package:training_journal/user.dart';

class UpcomingCard extends StatefulWidget {
  final Event event;
  final DBHelper db;
  final User user;
  const UpcomingCard({this.db, this.event, this.user});

  @override
  _UpcomingCardState createState() => _UpcomingCardState();
}

class _UpcomingCardState extends State<UpcomingCard> {
  DatabaseService firestore;

  void initState() {
    super.initState();
    firestore = DatabaseService(uid: widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: MediaQuery.of(context).size.width - 20, //380,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(15),
        ),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 30, 15, 30),
                child: Text("${widget.event.name}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
            Text(
              "${DateFormat('d/M/y').format(widget.event.date)}",
              style: TextStyle(
                fontSize: 26,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditEvent(
                                  user: widget.user,
                                  event: widget.event,
                                )));
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 80),
                  child: Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 60,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    _confirmDelete();
                  },
                ),
              ],
            ),
            Text(
              "${widget.event.startTime.format(context)}",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Event'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you would like to delete this?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Ok',
                style: TextStyle(color: Colors.blue[800]),
              ),
              onPressed: () async {
                firestore.deleteEvent(widget.event.id);
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home(
                              user: widget.user,
                            )));
              },
            ),
            FlatButton(
              child: Text(
                'CANCEL',
                style: TextStyle(color: Colors.blue[800]),
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
