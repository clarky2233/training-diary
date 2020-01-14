import 'package:flutter/material.dart';
import 'package:training_journal/user.dart';

class DOBInput extends StatefulWidget {
  final User user;
  final bool isEdit;
  const DOBInput({this.user, this.isEdit});

  @override
  _DOBInputState createState() => _DOBInputState();
}

class _DOBInputState extends State<DOBInput> {
  String original;

  final TextEditingController textController = new TextEditingController();

  @override
  void initState() {
    if (widget.isEdit) {
      textController.text = fromISO(widget.user.dob.toIso8601String());
      original = fromISO(widget.user.dob.toIso8601String());
    }
    super.initState();
  }

  String fromISO(String dobISO) {
    List<String> str = dobISO.split("-");
    String formatted = "${str[2].substring(0, 2)}/${str[1]}/${str[0]}";
    return formatted;
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
            widget.user.dob = DateTime.parse(toISO(text));
          });
        },
        style: TextStyle(
          fontSize: 22,
        ),
        decoration: InputDecoration(
            labelText: "Date of birth",
            labelStyle: TextStyle(color: Colors.black),
            hintText: "DD/MM/YYYY",
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
