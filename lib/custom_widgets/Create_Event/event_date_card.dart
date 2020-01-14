import 'package:flutter/material.dart';
import 'package:training_journal/event.dart';
import 'package:intl/intl.dart';

class EventDateCard extends StatefulWidget {

  final Event event;
  final bool isEdit;
  const EventDateCard({this.event, this.isEdit});

  @override
  _EventDateCardState createState() => _EventDateCardState();
}

class _EventDateCardState extends State<EventDateCard> {

  DateTime datetime;

  void initState() {
    if (widget.isEdit) {
      datetime = widget.event.date;
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
              "Date",
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
                    datetime == null ? 'Please select a date' : DateFormat.yMMMMd("en_US").format(datetime),
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
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(Duration(days: 1)),
                      lastDate: DateTime.now().add(Duration(days: 1000)),
                      builder: (BuildContext context, Widget child) {
                        return Theme(
                          data: ThemeData.dark(),
                          child: child,
                        );
                      },
                    ).then((date) {
                      setState(() {
                        datetime = date;
                        widget.event.date = datetime;
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