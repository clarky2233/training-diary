import 'package:flutter/material.dart';
import 'package:training_journal/training_session.dart';

class HydrationCard extends StatefulWidget {
  final TrainingSession ts;
  final bool isEdit;
  const HydrationCard({this.ts, this.isEdit});

  @override
  _HydrationCardState createState() => _HydrationCardState();
}

class _HydrationCardState extends State<HydrationCard> {
  static double sliderValue = 0.0;
  static double minValue = 0.0;
  static final double maxValue = 20.0;
  static double increments = 0.5;
  static int divisions = (maxValue ~/ increments).toInt();

  void initState() {
    if (widget.isEdit && widget.ts.hydration != null) {
      sliderValue = widget.ts.hydration;
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
                    "Hydration Levels",
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
              label: sliderValue.toString() + " Litres",
              onChanged: (newValue) {
                setState(() {
                  sliderValue = newValue;
                  widget.ts.hydration = sliderValue;
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
            'Hydration Levels',
            style: TextStyle(fontSize: 26),
          ),
          contentPadding: EdgeInsets.all(25),
          children: <Widget>[
            Text(
                '''This refers to the litres of water consumed the day of a training session.\n
If you have already recorded hydration levels for a training session today do not include previous volume of water.'''),
          ],
        );
      },
    );
  }
}
