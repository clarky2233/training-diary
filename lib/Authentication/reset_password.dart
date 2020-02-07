import 'package:flutter/material.dart';
import 'package:training_journal/Services/auth.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  String email = '';
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
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              child: FlatButton(
                onPressed: () async {
                  try {
                    dynamic result = await _auth.resetPassword(email);
                    if (result == Error) {
                      setState(() {
                        invalid = "Invalid Email";
                      });
                    } else {
                      setState(() {
                        invalid = "Email Sent";
                      });
                    }
                  } catch (e) {
                    setState(() {
                      invalid = "Invalid Email";
                    });
                  }
                },
                child: Text(
                  "Send Email",
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
