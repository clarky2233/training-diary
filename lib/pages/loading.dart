import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:training_journal/Authentication/authenticate.dart';
import 'package:training_journal/Database_helper.dart';
import 'package:training_journal/event.dart';
import 'package:training_journal/pages/create_profile.dart';
import 'package:training_journal/pages/home.dart';
import 'package:training_journal/training_session.dart';

import '../user.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  // DBHelper db;

  // void initState() {
  //   super.initState();
  //   db = DBHelper();
  //   db.setup();
  //   //checkProfileExists();
  // }

  // void checkProfileExists() async {
  //   if (await db.getUsersCount() != 0) {
  //     User user = await db.getUser(1);
  //     List<TrainingSession> recent = await db.lastTenSessions();
  //     List<Event> upcoming = await db.getEvents();
  //     Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => Home(
  //                   db: db,
  //                   user: user,
  //                   recentTen: recent,
  //                   upcoming: upcoming,
  //                 )));
  //   } else {
  //     Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => CreateProfile(
  //                   db: db,
  //                 )));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.redAccent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Training Diary+",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: SpinKitCircle(
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
