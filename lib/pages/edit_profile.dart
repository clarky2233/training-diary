import 'package:flutter/material.dart';
import 'package:training_journal/Services/firestore_database.dart';
import 'package:training_journal/custom_widgets/Create_Profile/full_name.dart';
import 'package:training_journal/custom_widgets/Create_Profile/height.dart';
import 'package:training_journal/custom_widgets/Create_Profile/restingHeartRate.dart';
import 'package:training_journal/custom_widgets/Create_Profile/username.dart';
import 'package:training_journal/custom_widgets/Create_Profile/weight.dart';
import 'package:training_journal/pages/profile_page.dart';
import 'package:training_journal/user.dart';

class EditProfile extends StatefulWidget {
  final User user;
  const EditProfile({@required this.user});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  User original;
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController usernameController = new TextEditingController();
  final TextEditingController dobController = new TextEditingController();
  DatabaseService firestore;

  void initState() {
    original = deepCopy(widget.user);
    nameController.text = widget.user.name;
    usernameController.text = widget.user.username;
    firestore = DatabaseService(uid: widget.user.id);
    super.initState();
  }

  User deepCopy(User user) {
    User original = User();
    original.id = user.id;
    original.name = user.name;
    original.username = user.username;
    original.weight = user.weight;
    original.height = user.height;
    original.restingHeartRate = user.restingHeartRate;
    return original;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfilePage(
                        user: original,
                      )));
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Edit Profile"),
            centerTitle: true,
            backgroundColor: Colors.redAccent,
            leading: FlatButton(
              onPressed: () async {
                FocusScope.of(context).requestFocus(new FocusNode());
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(
                              user: original,
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
                firestore.updateUserData(
                    widget.user.name,
                    widget.user.username,
                    widget.user.weight,
                    widget.user.height,
                    widget.user.restingHeartRate);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(
                              user: widget.user,
                            )));
              } else {
                _neverSatisfied();
              }
            },
            child: Icon(Icons.save),
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
