import 'package:flutter/material.dart';
import 'package:training_journal/training_session.dart';

class HeartRateCard extends StatefulWidget {
  final TrainingSession ts;
  final bool isEdit;
  const HeartRateCard({this.ts, this.isEdit});

  @override
  _HeartRateCardState createState() => _HeartRateCardState();
}

class _HeartRateCardState extends State<HeartRateCard> {
  static double sliderValue = 30.0;
  static double minValue = 30.0;
  static final double maxValue = 200.0;
  static int increments = 1;
  static int divisions = (maxValue ~/ increments).toInt();

  void initState() {
    if (widget.isEdit && widget.ts.heartRate != null) {
      if (widget.ts.heartRate < minValue) {
        sliderValue = minValue;
      } else {
        sliderValue = widget.ts.heartRate.toDouble();
      }
    } else {
      sliderValue = 30.0;
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
                    "Recovery Heart Rate",
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
              label: sliderValue.toInt().toString() + " bpm",
              onChanged: (newValue) {
                setState(() {
                  sliderValue = newValue;
                  widget.ts.heartRate = sliderValue.toInt();
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
            'Recovery Heart Rate',
            style: TextStyle(fontSize: 26),
          ),
          contentPadding: EdgeInsets.all(25),
          children: <Widget>[
            Text(
                '''Your Recovery Heart Rate, the speed at which your heart rate returns to normal after exercise, is one way to tell whether an exercise program is effective. Before embarking on a new exercise regimen, record your resting heart rate as a baseline and see how it improves over time with your new fitness efforts. It is usually best to record this the morning after a training session.'''),
          ],
        );
      },
    );
  }
}
