import 'package:flutter/material.dart';
import 'package:training_journal/user.dart';

class HeightInput extends StatefulWidget {
  final User user;
  final bool isEdit;
  const HeightInput({this.user, this.isEdit});

  @override
  _HeightInputState createState() => _HeightInputState();
}

class _HeightInputState extends State<HeightInput> {
  String original;

  final TextEditingController textController = new TextEditingController();

  @override
  void initState() {
    if (widget.isEdit && widget.user.height != null) {
      textController.text = widget.user.height.toString();
      original = widget.user.height.toString();
    } else {
      textController.text = "";
      original = "";
    }
    super.initState();
  }

  void getHeightInput(String text) {
    if (text == "") {
      widget.user.height = null;
      return;
    }
    try {
      widget.user.height = int.parse(text);
    } catch (e) {
      widget.user.height = -1234;
    }
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
            getHeightInput(text);
          });
        },
        style: TextStyle(
          fontSize: 22,
        ),
        decoration: InputDecoration(
            labelText: "Height (optional)",
            labelStyle: TextStyle(color: Colors.black),
            hintText: "Enter in Centimeters",
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
