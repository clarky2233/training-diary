import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:training_journal/training_session.dart';

class SleepRatingCard extends StatefulWidget {
  final TrainingSession ts;
  final bool isEdit;

  const SleepRatingCard({this.ts, this.isEdit});

  @override
  _SleepRatingCardState createState() => _SleepRatingCardState();
}

class _SleepRatingCardState extends State<SleepRatingCard> {
  double value = 0.0;

  void initState() {
    if (widget.isEdit && widget.ts.sleepRating != null) {
      value = widget.ts.sleepRating.toDouble();
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
                    "Sleep Rating",
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
            SmoothStarRating(
                allowHalfRating: false,
                onRatingChanged: (v) {
                  value = v;
                  setState(() {
                    widget.ts.sleepRating = value.toInt();
                  });
                },
                starCount: 5,
                rating: value,
                size: 40.0,
                filledIconData: Icons.grade,
                color: Colors.redAccent,
                borderColor: Colors.redAccent,
                spacing: 0.0),
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
                '''This refers to the rating of sleep for the night before a training session.'''),
          ],
        );
      },
    );
  }
}
