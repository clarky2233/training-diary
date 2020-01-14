import 'package:flutter/material.dart';
import 'package:training_journal/training_session.dart';
import 'package:intl/intl.dart';

class DateCard extends StatefulWidget {

  final TrainingSession ts;
  final bool isEdit;
  const DateCard({this.ts, this.isEdit});

  @override
  _DateCardState createState() => _DateCardState();
}

class _DateCardState extends State<DateCard> {

  DateTime datetime;

  void initState() {
    if (widget.isEdit && widget.ts.date != null) {
      datetime = widget.ts.date;
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
                      firstDate: DateTime(2018),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                      builder: (BuildContext context, Widget child) {
                        return Theme(
                          data: ThemeData.dark(),
                          child: child,
                        );
                      },
                    ).then((date) {
                      setState(() {
                        datetime = date;
                        widget.ts.date = datetime;
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