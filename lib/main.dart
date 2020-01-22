import 'package:flutter/material.dart';
import 'package:training_journal/Authentication/authenticate.dart';
import 'package:training_journal/Services/auth.dart';
import 'package:training_journal/pages/loading.dart';
import 'package:provider/provider.dart';
import 'package:training_journal/user.dart';
import 'package:training_journal/wrapper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
        // initialRoute: '/loading',
        // routes: {
        //   '/loading': (context) => Loading(),
        // },
      ),
    );
  }
}
