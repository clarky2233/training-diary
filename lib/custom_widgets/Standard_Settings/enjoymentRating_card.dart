import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:training_journal/training_session.dart';

class EnjoymentRatingCard extends StatefulWidget {
  final String name;
  final TrainingSession ts;
  final bool isEdit;

  const EnjoymentRatingCard({this.name, this.ts, this.isEdit});

  @override
  _EnjoymentRatingCardState createState() => _EnjoymentRatingCardState();
}

class _EnjoymentRatingCardState extends State<EnjoymentRatingCard> {
  double value = 0.0;

  void initState() {
    if (widget.isEdit && widget.ts.enjoymentRating != null) {
      value = widget.ts.enjoymentRating.toDouble();
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
              "${widget.name}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            SmoothStarRating(
                allowHalfRating: false,
                onRatingChanged: (v) {
                  value = v;
                  setState(() {
                    widget.ts.enjoymentRating = value.toInt();
                  });
                },
                starCount: 5,
                rating: value,
                size: 40.0,
                filledIconData: Icons.grade,
                color: Colors.pink,
                borderColor: Colors.pink,
                spacing: 0.0),
          ],
        ),
      ),
    );
  }
}
