import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:training_journal/custom_widgets/Home_Page/more_info.dart';
import 'package:training_journal/training_session.dart';
import 'package:training_journal/user.dart';

class SmallSessionCard extends StatefulWidget {
  final TrainingSession ts;
  final User user;
  const SmallSessionCard({@required this.ts, @required this.user});

  @override
  _SmallSessionCardState createState() => _SmallSessionCardState();
}

class _SmallSessionCardState extends State<SmallSessionCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MoreInfo(
                      user: widget.user,
                      ts: widget.ts,
                      returnHome: false,
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
                    alignment: Alignment.center,
                    child: Icon(
                      widget.ts.activity.icon,
                      size: 40,
                      color: Colors.redAccent,
                    ),
                  ),
                  Center(
                    child: Text(
                      "${DateFormat('d/M/y').format(widget.ts.date)}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
