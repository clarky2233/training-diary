import 'package:flutter/material.dart';
import 'package:training_journal/user.dart';

class UsernameInput extends StatefulWidget {
  final User user;
  final bool isEdit;
  const UsernameInput({this.user, this.isEdit});

  @override
  _UsernameInputState createState() => _UsernameInputState();
}

class _UsernameInputState extends State<UsernameInput> {
  String original;

  final TextEditingController textController = new TextEditingController();

  @override
  void initState() {
    if (widget.isEdit) {
      textController.text = widget.user.username;
      original = widget.user.username;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextFormField(
        maxLines: 1,
        controller: textController,
        cursorColor: Colors.redAccent,
        onChanged: (text) {
          setState(() {
            widget.user.username = text;
          });
        },
        style: TextStyle(
          fontSize: 22,
        ),
        decoration: InputDecoration(
            labelText: "Username",
            labelStyle: TextStyle(color: Colors.black),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent),
            )),
      ),
    );
  }
}
