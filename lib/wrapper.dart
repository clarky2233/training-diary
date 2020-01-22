import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:training_journal/Authentication/authenticate.dart';
import 'package:training_journal/Database_helper.dart';
import 'package:training_journal/pages/home.dart';
import 'package:training_journal/user.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  DBHelper db;

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
      return Home(
        db: db,
        user: user,
        recentTen: null,
        upcoming: null,
      );
    }
  }
}
