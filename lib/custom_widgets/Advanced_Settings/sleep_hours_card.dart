import 'package:flutter/material.dart';
import 'package:training_journal/training_session.dart';

class SleepHoursCard extends StatefulWidget {
  final TrainingSession ts;
  final bool isEdit;
  const SleepHoursCard({this.ts, this.isEdit});

  @override
  _SleepHoursCardState createState() => _SleepHoursCardState();
}

class _SleepHoursCardState extends State<SleepHoursCard> {
  static double sliderValue = 0.0;
  static double minValue = 0.0;
  static final double maxValue = 24.0;
  static double increments = 0.5;
  static int divisions = (maxValue ~/ increments).toInt();

  void initState() {
    if (widget.isEdit && widget.ts.hoursOfSleep != null) {
      sliderValue = widget.ts.hoursOfSleep;
    } else {
      sliderValue = 0.0;
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
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Hours of Sleep",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.info_outline),
                  onPressed: () {
                    _moreInfo();
                  },
                ),
              ],
            ),
            Slider(
              min: minValue,
              max: maxValue,
              value: sliderValue,
              divisions: divisions,
              activeColor: Colors.redAccent,
              inactiveColor: Colors.red[100],
              label: sliderValue.toString() + " hrs",
              onChanged: (newValue) {
                setState(() {
                  sliderValue = newValue;
                  widget.ts.hoursOfSleep = sliderValue;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _moreInfo() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            'Hours of Sleep',
            style: TextStyle(fontSize: 26),
          ),
          contentPadding: EdgeInsets.all(25),
          children: <Widget>[
            Text(
                '''This refers to the number of hours of sleep the night before a training session.'''),
          ],
        );
      },
    );
  }
}
