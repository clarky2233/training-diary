import 'package:flutter/material.dart';
import 'package:training_journal/training_session.dart';

class RPECard extends StatefulWidget {
  final TrainingSession ts;
  final bool isEdit;
  const RPECard({this.ts, this.isEdit});

  @override
  _RPECardState createState() => _RPECardState();
}

class _RPECardState extends State<RPECard> {
  static double sliderValue = 6.0;
  static double minValue = 6.0;
  static final double maxValue = 20.0;
  static int increments = 1;
  static int divisions = (maxValue ~/ increments).toInt();

  void initState() {
    if (widget.isEdit && widget.ts.rpe != null) {
      if (widget.ts.rpe < minValue) {
        widget.ts.rpe = minValue.toInt();
      } else {
        sliderValue = widget.ts.rpe.toDouble();
      }
    } else {
      sliderValue = 6.0;
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
                    "Percieved Rate of Exertion",
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
              activeColor: Colors.pink[400],
              inactiveColor: Colors.pink[100],
              label: sliderValue.toInt().toString(),
              onChanged: (newValue) {
                setState(() {
                  sliderValue = newValue;
                  widget.ts.rpe = sliderValue.toInt();
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
            'Percieved Rate of Exertion',
            style: TextStyle(fontSize: 26),
          ),
          contentPadding: EdgeInsets.all(25),
          children: <Widget>[
            Text(
                '''The rating of perceived exertion (RPE) is used to assess the intensity of training and competition.
            
            6 - No exertion at all
            7 - Extremely light
            8
            9 - Very light
            10
            11 - Light
            12
            13 - Somewhat hard
            14
            15 - Hard
            16
            17 - Very hard
            18
            19 - Extremely hard
            20 - Maximum exertion'''),
          ],
        );
      },
    );
  }
}
