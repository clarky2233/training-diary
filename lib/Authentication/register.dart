import 'package:flutter/material.dart';
import 'package:training_journal/Services/auth.dart';
import 'package:training_journal/pages/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email = '';
  String password = '';
  String name = '';
  String username = '';
  String error = '';
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();

    return loading
        ? Loading()
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            home: WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.redAccent,
                  elevation: 0,
                  title: Text(
                    "Register",
                    style: TextStyle(fontSize: 25),
                  ),
                  actions: <Widget>[
                    FlatButton.icon(
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Sign in",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        widget.toggleView();
                      },
                    )
                  ],
                ),
                body: SingleChildScrollView(
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 50),
                              child: Center(
                                child: Text(
                                  "Welcome to\nTraining Diary+",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: TextFormField(
                                validator: (val) =>
                                    val.isEmpty ? 'Enter your name' : null,
                                cursorColor: Colors.redAccent,
                                decoration: InputDecoration(
                                    labelText: "Full name",
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.redAccent),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.redAccent),
                                    )),
                                onChanged: (val) {
                                  setState(() {
                                    name = val;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: TextFormField(
                                validator: (val) =>
                                    val.isEmpty ? 'Enter an Email' : null,
                                cursorColor: Colors.redAccent,
                                decoration: InputDecoration(
                                    labelText: "Email",
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.redAccent),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.redAccent),
                                    )),
                                onChanged: (val) {
                                  setState(() {
                                    email = val;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: TextFormField(
                                validator: (val) =>
                                    val.isEmpty ? 'Enter a Username' : null,
                                cursorColor: Colors.redAccent,
                                decoration: InputDecoration(
                                    labelText: "Username",
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.redAccent),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.redAccent),
                                    )),
                                onChanged: (val) {
                                  setState(() {
                                    username = val;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: TextFormField(
                                validator: (val) => val.length < 6
                                    ? 'Enter a password 6 or more charaters long'
                                    : null,
                                cursorColor: Colors.redAccent,
                                decoration: InputDecoration(
                                    labelText: "Password",
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.redAccent),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.redAccent),
                                    )),
                                obscureText: true,
                                onChanged: (val) {
                                  setState(() {
                                    password = val;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: RaisedButton(
                                color: Colors.redAccent,
                                child: Text(
                                  "Register",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    dynamic result = await _auth.register(
                                        email, password, name, username);
                                    if (result == null) {
                                      setState(() {
                                        error = "Oops! Something went wrong";
                                        loading = false;
                                      });
                                    }
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                error,
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
