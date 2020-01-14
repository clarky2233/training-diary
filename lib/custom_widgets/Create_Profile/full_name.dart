import 'package:flutter/material.dart';
import 'package:training_journal/user.dart';

class FullNameInput extends StatefulWidget {
  final User user;
  final bool isEdit;
  const FullNameInput({this.user, this.isEdit});

  @override
  _FullNameInputState createState() => _FullNameInputState();
}

class _FullNameInputState extends State<FullNameInput> {
  String original;

  final TextEditingController textController = new TextEditingController();

  @override
  void initState() {
    if (widget.isEdit) {
      textController.text = widget.user.name;
      original = widget.user.name;
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
        cursorColor: Colors.pink[400],
        onChanged: (text) {
          setState(() {
            widget.user.name = text;
          });
        },
        style: TextStyle(
          fontSize: 22,
        ),
        decoration: InputDecoration(
            labelText: "Full name",
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.pink[400]),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.pink[400]),
            )),
      ),
    );
  }
}
