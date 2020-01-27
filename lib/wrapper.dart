import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:training_journal/Authentication/authenticate.dart';
import 'package:training_journal/Database_helper.dart';
import 'package:training_journal/Services/firestore_database.dart';
import 'package:training_journal/pages/home.dart';
import 'package:training_journal/pages/home_2.dart';
import 'package:training_journal/user.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  DBHelper db;
  DatabaseService firestore = DatabaseService();

  void initState() {
    super.initState();
    db = DBHelper();
    db.setup();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return FutureBuilder<User>(
          future: firestore.getUser(),
          builder: (context, snapshot) {
            return Home2(
              db: db,
              user: snapshot.data,
            );
          });
    }
  }
}
