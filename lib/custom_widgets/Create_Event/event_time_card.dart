import 'package:flutter/material.dart';
import 'package:training_journal/event.dart';

class EventTimeCard extends StatefulWidget {

  final Event event;
  final bool isEdit;
  const EventTimeCard({this.event, this.isEdit});

  @override
  _EventTimeCardState createState() => _EventTimeCardState();
}

class _EventTimeCardState extends State<EventTimeCard> {

  TimeOfDay startTime;

  void initState() {
    if (widget.isEdit) {
      startTime = widget.event.startTime;
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
              "Start Time",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),              
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                    startTime == null ? 'Please select a time' : startTime.format(context),
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    size: 30,
                  ),
                  onPressed: () {
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (BuildContext context, Widget child) {
                        return Theme(
                          data: ThemeData.dark(),
                          child: child,
                        );
                      },
                    ).then((date) {
                      setState(() {
                        startTime = date;
                        widget.event.startTime = startTime;
                      });
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}