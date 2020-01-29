import 'package:flutter/material.dart';
import 'package:flutter_star_rating/flutter_star_rating.dart';
import 'package:intl/intl.dart';
import 'package:training_journal/Database_helper.dart';
import 'package:training_journal/Services/firestore_database.dart';
import 'package:training_journal/pages/all_entries.dart';
import 'package:training_journal/pages/home_2.dart';
import 'package:training_journal/training_session.dart';
import 'package:training_journal/pages/edit_session.dart';
import 'package:training_journal/user.dart';

class MoreInfo extends StatefulWidget {
  final TrainingSession ts;
  final DBHelper db;
  final User user;
  final bool returnHome;
  const MoreInfo({this.ts, this.db, this.user, this.returnHome});

  @override
  _MoreInfoState createState() => _MoreInfoState();
}

class _MoreInfoState extends State<MoreInfo> {
  String description;
  String heartRate;
  String rpe;
  String hoursOfSleep;
  double sleepRating;
  double enjoymentRating;
  String hydration;

  DatabaseService firestore;

  void initState() {
    super.initState();
    firestore = DatabaseService(uid: widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.ts.description == null) {
      description = "No description";
    } else {
      description = widget.ts.description;
    }
    if (widget.ts.heartRate == null) {
      heartRate = "N/A";
    } else {
      heartRate = widget.ts.heartRate.toString() + " bpm";
    }
    if (widget.ts.rpe == null) {
      rpe = "N/A";
    } else {
      rpe = widget.ts.rpe.toString() + " / 20";
    }
    if (widget.ts.hoursOfSleep == null) {
      hoursOfSleep = "N/A";
    } else {
      hoursOfSleep = widget.ts.hoursOfSleep.toString() + " hrs";
    }
    if (widget.ts.hydration == null) {
      hydration = "N/A";
    } else {
      hydration = widget.ts.hydration.toString() + " Litres";
    }
    if (widget.ts.sleepRating == null) {
      sleepRating = 0.0;
    } else {
      sleepRating = widget.ts.sleepRating.toDouble();
    }
    if (widget.ts.enjoymentRating == null) {
      enjoymentRating = 0.0;
    } else {
      enjoymentRating = widget.ts.enjoymentRating.toDouble();
    }

    return MaterialApp(
      home: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("More Info"),
            backgroundColor: Colors.redAccent,
            centerTitle: true,
            leading: FlatButton(
              onPressed: () async {
                FocusScope.of(context).requestFocus(new FocusNode());
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  if (widget.returnHome) {
                    return Home2(
                      user: widget.user,
                    );
                  } else {
                    return EntriesPage(
                      user: widget.user,
                    );
                  }
                }));
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditSession(
                                user: widget.user,
                                ts: widget.ts,
                                returnHome: widget.returnHome,
                              )));
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _confirmDelete();
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "${widget.ts.title}",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Date:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "${DateFormat('d/M/y').format(widget.ts.date)}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          "Activity:",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                        Text(
                          "${widget.ts.activity.name}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Icon(widget.ts.activity.icon),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Duration:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "${formatDuration(widget.ts.duration)}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text("Intensity:",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold))),
                        StarRating(
                          rating: widget.ts.difficulty.toDouble(),
                          spaceBetween: 2,
                          starConfig: StarConfig(
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text("Overall Enjoyment:",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold))),
                        StarRating(
                          rating: enjoymentRating,
                          spaceBetween: 2,
                          starConfig: StarConfig(
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Description:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "$description",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Recovery Heart Rate:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "$heartRate",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Rate of Percieved Exertion:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "$rpe",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Hours of sleep:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "$hoursOfSleep ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          "Sleep Rating:",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                        StarRating(
                          rating: sleepRating,
                          spaceBetween: 2,
                          starConfig: StarConfig(
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Hydration Levels:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "$hydration",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
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
          title: Text('Delete Training Session'),
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
                firestore.deleteTrainingSession(widget.ts.id);
                Navigator.of(context).pop();
                if (widget.returnHome) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Home2(
                                user: widget.user,
                              )));
                } else {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EntriesPage(
                                user: widget.user,
                              )));
                }
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

  String formatDuration(int duration) {
    if (duration < 60) {
      return "$duration mins";
    } else {
      int minutes = duration % 60;
      int hours = (duration ~/ 60).toInt();
      if (minutes == 0) {
        if (hours == 1) {
          return "$hours hr";
        } else {
          return "$hours hrs";
        }
      }
      if (hours == 1) {
        return "$hours hr $minutes mins";
      } else {
        return "$hours hrs $minutes mins";
      }
    }
  }
}
