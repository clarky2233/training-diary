import 'package:flutter/material.dart';
import 'package:training_journal/training_session.dart';

class DurationCard extends StatefulWidget {
  final TrainingSession ts;
  final bool isEdit;
  const DurationCard({this.ts, this.isEdit});

  @override
  _DurationCardState createState() => _DurationCardState();
}

class _DurationCardState extends State<DurationCard> {
  static double sliderValue = 0.0;
  static double minValue = 0.0;
  static final double maxValue = 300.0;
  static int increments = 5;
  static int divisions = (maxValue ~/ increments).toInt();

  void initState() {
    if (widget.isEdit && widget.ts.duration != null) {
      sliderValue = widget.ts.duration.toDouble();
    } else {
      sliderValue = 0;
    }
    super.initState();
  }

  String formatDuration(int duration) {
    if (duration < 60) {
      return "$duration mins";
    } else {
      int minutes = duration % 60;
      int hours = (duration ~/ 60).toInt();
      if (minutes == 0) {
        if (hours == 1) {
          return "$hours hr";
        } else {
          return "$hours hrs";
        }
      }
      if (hours == 1) {
        return "$hours hr $minutes mins";
      } else {
        return "$hours hrs $minutes mins";
      }
    }
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
              "Duration",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Slider(
              min: minValue,
              max: maxValue,
              value: sliderValue,
              divisions: divisions,
              activeColor: Colors.red[400],
              inactiveColor: Colors.red[100],
              label: formatDuration(sliderValue.toInt()),
              onChanged: (newValue) {
                setState(() {
                  sliderValue = newValue;
                  widget.ts.duration = sliderValue.toInt();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
