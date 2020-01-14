import 'package:flutter/material.dart';
import 'package:training_journal/user.dart';

class WeightInput extends StatefulWidget {
  final User user;
  final bool isEdit;
  const WeightInput({this.user, this.isEdit});

  @override
  _WeightInputState createState() => _WeightInputState();
}

class _WeightInputState extends State<WeightInput> {
  String original;

  final TextEditingController textController = new TextEditingController();

  @override
  void initState() {
    if (widget.isEdit && widget.user.weight != null) {
      textController.text = widget.user.weight.toString();
      original = widget.user.weight.toString();
    } else {
      textController.text = "";
      original = "";
    }
    super.initState();
  }

  void getWeightInput(String text) {
    if (text == "") {
      widget.user.weight = null;
      return;
    }
    try {
      widget.user.weight = double.parse(text);
    } catch (e) {
      widget.user.weight = -1234.0;
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
            getWeightInput(text);
          });
        },
        style: TextStyle(
          fontSize: 22,
        ),
        decoration: InputDecoration(
            labelText: "Weight (optional)",
            labelStyle: TextStyle(color: Colors.black),
            hintText: "Enter in Kilograms",
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
