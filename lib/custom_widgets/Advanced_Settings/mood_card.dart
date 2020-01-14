import 'package:flutter/material.dart';
import 'package:training_journal/training_session.dart';

class MoodCard extends StatefulWidget {

  final TrainingSession ts;
  final bool isEdit;
  const MoodCard({this.ts, this.isEdit});

  @override
  _MoodCardState createState() => _MoodCardState();
}

class _MoodCardState extends State<MoodCard> {

  String mood;

  void initState() {
    if (widget.isEdit) {
      mood = widget.ts.mood;
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
            Text(
              "Mood",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),              
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: 400,
              child: DropdownButton<String>(
                value: mood == null ? 'Please Select' : mood,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black
                ),
                underline: Container(
                  height: 2,
                  color: Colors.pinkAccent,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    mood = newValue;
                  });
                },
                items: <String>['Please Select', 'One', 'Two', 'Free', 'Four']
                  .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  })
                  .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}