import 'package:flutter/material.dart';
import 'package:training_journal/training_session.dart';

class DescriptionCard extends StatefulWidget {
  final TrainingSession ts;
  final bool isEdit;
  const DescriptionCard({this.ts, this.isEdit});

  @override
  _DescriptionCardState createState() => _DescriptionCardState();
}

class _DescriptionCardState extends State<DescriptionCard> {
  String descriptionValue;

  final TextEditingController textController = new TextEditingController();

  @override
  void initState() {
    if (widget.isEdit) {
      textController.text = widget.ts.description;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 15, 10, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
              child: Text(
                "Description",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            TextField(
              maxLines: 10,
              cursorColor: Colors.redAccent,
              controller: textController,
              onChanged: (text) {
                setState(() {
                  descriptionValue = text;
                  widget.ts.description = descriptionValue;
                });
              },
              style: TextStyle(
                fontSize: 16,
              ),
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.redAccent)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.redAccent))),
            ),
          ],
        ),
      ),
    );
  }
}
