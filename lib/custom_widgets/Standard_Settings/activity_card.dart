import 'package:flutter/material.dart';
import 'package:training_journal/activities.dart';
import 'package:training_journal/training_session.dart';

class ActivityCard extends StatefulWidget {

  final TrainingSession ts;
  final bool isEdit;
  const ActivityCard({this.ts, this.isEdit});

  @override
  _ActivityCardState createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  int value = -1;

  bool isSelected = false;

  void initState() {
    if (widget.isEdit && widget.ts.activity != null) {
      value = Activities.activities.indexOf(widget.ts.activity);
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
              "Activity",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),              
            ),
            Wrap(
              spacing: 15.0,
              runSpacing: 3.0,
              children: List<Widget>.generate(Activities.activities.length, (index) {
                return ChoiceChip(
                  label: Text(
                    Activities.activities[index].name,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                  avatar:Icon(Activities.activities[index].icon),
                  selected: value == index,
                  selectedColor: Colors.pink[200],
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        if (value != index) {
                          value = index;
                          widget.ts.activity = Activities.activities[value];
                        }
                      }
                      //value = selected ? index : null;
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}