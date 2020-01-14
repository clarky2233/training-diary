import 'package:flutter/material.dart';
import 'package:training_journal/Database_helper.dart';
import 'package:training_journal/pages/all_entries.dart';
import 'package:training_journal/training_session.dart';
import 'package:training_journal/user.dart';

class ClearFilter extends StatefulWidget {

  final DBHelper db;
  final User user;
  final bool shouldClear;
  const ClearFilter({this.db, this.user, this.shouldClear});
  
  @override
  _ClearFilterState createState() => _ClearFilterState();
}

class _ClearFilterState extends State<ClearFilter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          FlatButton(
            child: Row(
              children: <Widget>[
                Text("Clear"),
                Icon(Icons.clear, size: 20,),
              ],
            ),
            onPressed: () async {
              if (widget.shouldClear) {
                List<TrainingSession> allEntries = await widget.db.getJournal();
                Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(
                      builder: (context) {
                        return EntriesPage(allEntries: allEntries, db: widget.db, user: widget.user,);
                      }
                    )
                  );
              }
              }
          ),
        ]
      )
    );
  }
           
}