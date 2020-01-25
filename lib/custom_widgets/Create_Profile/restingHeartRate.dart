import 'package:flutter/material.dart';
import 'package:training_journal/user.dart';

class RestingHeartRateInput extends StatefulWidget {
  final User user;
  final bool isEdit;
  const RestingHeartRateInput({this.user, this.isEdit});

  @override
  _RestingHeartRateInputState createState() => _RestingHeartRateInputState();
}

class _RestingHeartRateInputState extends State<RestingHeartRateInput> {
  String original;

  final TextEditingController textController = new TextEditingController();

  @override
  void initState() {
    if (widget.isEdit && widget.user.restingHeartRate != null) {
      textController.text = widget.user.restingHeartRate.toString();
      original = widget.user.restingHeartRate.toString();
    } else {
      textController.text = "";
      original = "";
    }
    super.initState();
  }

  void getRHRInput(String text) {
    if (text == "") {
      widget.user.restingHeartRate = null;
      return;
    }
    try {
      widget.user.restingHeartRate = int.parse(text);
    } catch (e) {
      widget.user.restingHeartRate = -1234;
    }
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
            getRHRInput(text);
          });
        },
        style: TextStyle(
          fontSize: 22,
        ),
        decoration: InputDecoration(
            labelText: "Resting Heart Rate (optional)",
            labelStyle: TextStyle(color: Colors.black),
            hintText: "Enter in BPM",
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
