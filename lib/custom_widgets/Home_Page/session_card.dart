import 'package:flutter/material.dart';
import 'package:flutter_star_rating/flutter_star_rating.dart';
import 'package:intl/intl.dart';
import 'package:training_journal/Database_helper.dart';
import 'package:training_journal/custom_widgets/Home_Page/more_info.dart';
import 'package:training_journal/training_session.dart';
import 'package:training_journal/user.dart';

class SessionCard extends StatefulWidget {
  final TrainingSession ts;
  final DBHelper db;
  final User user;
  const SessionCard({this.ts, this.db, this.user});

  @override
  _SessionCardState createState() => _SessionCardState();
}

class _SessionCardState extends State<SessionCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MoreInfo(
                      db: widget.db,
                      user: widget.user,
                      ts: widget.ts,
                      returnHome: true,
                    )));
      },
      child: Container(
          width: 180,
          margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "${widget.ts.title}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(30),
                    alignment: Alignment.center,
                    child: Icon(
                      widget.ts.activity.icon,
                      size: 60,
                    ),
                  ),
                  Center(
                    child: Text(
                      "${DateFormat('d/M/y').format(widget.ts.date)}",
                    ),
                  ),
                  StarRating(
                    rating: widget.ts.difficulty.toDouble(),
                    spaceBetween: 2,
                    starConfig: StarConfig(
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
