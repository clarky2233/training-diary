import 'package:flutter/material.dart';
import 'package:training_journal/Database_helper.dart';
import 'package:training_journal/custom_widgets/Create_Profile/dob.dart';
import 'package:training_journal/custom_widgets/Create_Profile/full_name.dart';
import 'package:training_journal/custom_widgets/Create_Profile/height.dart';
import 'package:training_journal/custom_widgets/Create_Profile/restingHeartRate.dart';
import 'package:training_journal/custom_widgets/Create_Profile/username.dart';
import 'package:training_journal/custom_widgets/Create_Profile/weight.dart';
import 'package:training_journal/pages/profile_page.dart';
import 'package:training_journal/user.dart';

class EditProfile extends StatefulWidget {
  final DBHelper db;
  final User user;
  const EditProfile({@required this.db, @required this.user});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  User original;
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController usernameController = new TextEditingController();
  final TextEditingController dobController = new TextEditingController();

  void initState() {
    original = deepCopy(widget.user);
    nameController.text = widget.user.name;
    usernameController.text = widget.user.username;
    dobController.text = fromISO(widget.user.dob.toIso8601String());
    original = deepCopy(widget.user);
    super.initState();
  }

  User deepCopy(User user) {
    User original = User();
    original.id = user.id;
    original.name = user.name;
    original.username = user.username;
    original.dob = user.dob;
    return original;
  }

  String toISO(String date) {
    List dateparts = date.split('/');
    if (dateparts.length != 3) {
      return null;
    }
    String dateString =
        "${dateparts[2]}-${dateparts[1]}-${dateparts[0]} 00:00:00.000";
    return dateString;
  }

  String fromISO(String dobISO) {
    List<String> str = dobISO.split("-");
    String formatted = "${str[2].substring(0, 2)}/${str[1]}/${str[0]}";
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Edit Profile"),
            centerTitle: true,
            backgroundColor: Colors.pink[500],
            leading: FlatButton(
              onPressed: () async {
                FocusScope.of(context).requestFocus(new FocusNode());
                await widget.db.updateUser(original);
                List<Goal> goals = await widget.db.getGoals();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(
                              db: widget.db,
                              user: original,
                              goals: goals,
                            )));
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  FullNameInput(
                    user: widget.user,
                    isEdit: true,
                  ),
                  UsernameInput(
                    user: widget.user,
                    isEdit: true,
                  ),
                  DOBInput(
                    user: widget.user,
                    isEdit: true,
                  ),
                  WeightInput(
                    user: widget.user,
                    isEdit: true,
                  ),
                  HeightInput(
                    user: widget.user,
                    isEdit: true,
                  ),
                  RestingHeartRateInput(
                    user: widget.user,
                    isEdit: true,
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (User.isValid(widget.user)) {
                FocusScope.of(context).requestFocus(new FocusNode());
                await widget.db.updateUser(widget.user);
                List<Goal> goals = await widget.db.getGoals();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(
                              db: widget.db,
                              user: widget.user,
                              goals: goals,
                            )));
              } else {
                _neverSatisfied();
              }
            },
            child: Icon(Icons.save),
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
          title: Text('Bad Data'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please complete all available fields.\n'),
                Text('Ensure the date is in the format:\n'),
                Text('  - DD/MM/YYYY'),
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
