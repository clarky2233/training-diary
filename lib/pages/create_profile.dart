import 'package:flutter/material.dart';
import 'package:training_journal/Database_helper.dart';
import 'package:training_journal/custom_widgets/Create_Profile/full_name.dart';
import 'package:training_journal/custom_widgets/Create_Profile/height.dart';
import 'package:training_journal/custom_widgets/Create_Profile/restingHeartRate.dart';
import 'package:training_journal/custom_widgets/Create_Profile/username.dart';
import 'package:training_journal/custom_widgets/Create_Profile/weight.dart';
import 'package:training_journal/event.dart';
import 'package:training_journal/pages/home.dart';
import 'package:training_journal/training_session.dart';
import 'package:training_journal/user.dart';

class CreateProfile extends StatefulWidget {
  final DBHelper db;
  const CreateProfile({@required this.db});

  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  User user = User();

  String toISO(String date) {
    List dateparts = date.split('/');
    if (dateparts.length != 3) {
      return null;
    }
    String dateString =
        "${dateparts[2]}-${dateparts[1]}-${dateparts[0]} 00:00:00.000";
    return dateString;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 250,
                  color: Colors.pinkAccent,
                  child: Center(
                    child: Text(
                      "Training Diary+",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.grey[200],
                  elevation: 0,
                  shape: ContinuousRectangleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Text(
                      "Create a profile",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                FullNameInput(
                  user: user,
                  isEdit: false,
                ),
                UsernameInput(
                  user: user,
                  isEdit: false,
                ),
                // DOBInput(
                //   user: user,
                //   isEdit: false,
                // ),
                WeightInput(
                  user: user,
                  isEdit: false,
                ),
                HeightInput(
                  user: user,
                  isEdit: false,
                ),
                RestingHeartRateInput(
                  user: user,
                  isEdit: false,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            user.dob = DateTime.parse(toISO("01/01/1900"));
            if (User.isValid(user)) {
              FocusScope.of(context).requestFocus(new FocusNode());
              await widget.db.insertUser(user);
              List<TrainingSession> recentTen =
                  await widget.db.lastTenSessions();
              List<Event> upcoming = await widget.db.getEvents();
              User mainUser = await widget.db.getUser(1);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home(
                            db: widget.db,
                            user: mainUser,
                            recentTen: recentTen,
                            upcoming: upcoming,
                          )));
            } else {
              _neverSatisfied();
            }
          },
          child: Icon(Icons.arrow_forward),
          backgroundColor: Colors.pink[600],
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
          title: Text('Bad Data'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please complete all available fields.\n'),
                Text('\nEnsure the weight is a decimal number'),
                Text('  - E.g. 80.40'),
                Text('\nEnsure the height is a whole number'),
                Text('  - E.g. 183'),
                Text('\nEnsure the heart rate is a whole number'),
                Text('  - E.g. 60'),
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
