import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:training_journal/Services/auth.dart';

class ReAthenticate extends StatefulWidget {
  @override
  _ReAthenticateState createState() => _ReAthenticateState();
}

class _ReAthenticateState extends State<ReAthenticate> {
  String email = '';
  String password = '';
  String invalid;
  final AuthService _auth = AuthService();

  void initState() {
    super.initState();
    invalid = '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            maxLines: 1,
            cursorColor: Colors.pink[400],
            onChanged: (text) {
              setState(() {
                email = text;
              });
            },
            style: TextStyle(
              fontSize: 20,
            ),
            decoration: InputDecoration(
                hintText: "Email",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent),
                )),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: TextField(
            maxLines: 1,
            obscureText: true,
            cursorColor: Colors.redAccent,
            onChanged: (text) {
              setState(() {
                password = text;
              });
            },
            style: TextStyle(
              fontSize: 16,
            ),
            decoration: InputDecoration(
                hintText: "Password",
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent[400])),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent[400]))),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              child: FlatButton(
                onPressed: () async {
                  try {
                    AuthCredential credential = EmailAuthProvider.getCredential(
                        email: email, password: password);
                    await _auth.reAuthenticateUser(credential);
                    await _auth.deleteUser();
                    Navigator.of(context).pop();
                  } catch (e) {
                    setState(() {
                      invalid = "Invalid Credentials";
                    });
                  }
                },
                child: Text(
                  "Confirm Delete",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              child: FlatButton(
                onPressed: () {
                  setState(() {
                    invalid = '';
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              invalid,
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        )
      ],
    );
  }
}
