import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:training_journal/Database_helper.dart';
import 'package:training_journal/pages/all_entries.dart';
import 'package:training_journal/training_session.dart';
import 'package:training_journal/user.dart';

class DateFilter extends StatefulWidget {
  final DBHelper db;
  final User user;
  const DateFilter({this.db, this.user});

  @override
  _DateFilterState createState() => _DateFilterState();
}

class _DateFilterState extends State<DateFilter> {
  DateTime selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    if (selectedMonth == null) {
      selectedMonth = DateTime.now();
    }
    return Container(
      child: Row(
        children: <Widget>[
          FlatButton(
            child: Row(
              children: <Widget>[
                Text("Date"),
                Icon(Icons.arrow_drop_down),
              ],
            ),
            onPressed: () {
              showMonthPicker(
                context: context,
                initialDate: selectedMonth,
              ).then((date) async {
                setState(() {
                  selectedMonth = date;
                });
                try {
                  List<TrainingSession> filteredList =
                      await widget.db.getFiltered(date);
                  String str = DateFormat.yMMMM("en_US").format(date);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return EntriesPage(
                      allEntries: filteredList,
                      db: widget.db,
                      user: widget.user,
                      currentFilter: str,
                    );
                  }));
                } catch (e) {}
              });
            },
          ),
        ],
      ),
    );
  }
}
