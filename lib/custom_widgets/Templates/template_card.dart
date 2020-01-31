import 'package:flutter/material.dart';
import 'package:training_journal/Database_helper.dart';
import 'package:training_journal/Services/firestore_database.dart';
import 'package:training_journal/pages/create_session_from_template.dart';
import 'package:training_journal/pages/templates.dart';
import 'package:training_journal/training_session.dart';
import 'package:training_journal/user.dart';

class TemplateCard extends StatefulWidget {
  final DBHelper db;
  final User user;
  final TrainingSession template;

  const TemplateCard({this.db, this.user, this.template});

  @override
  _TemplateCardState createState() => _TemplateCardState();
}

class _TemplateCardState extends State<TemplateCard> {
  String description;
  String titleStr;
  DatabaseService firestore;

  void intiState() {
    super.initState();
    firestore = DatabaseService(uid: widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.template.description == null) {
      description = "No Descritpion";
    } else {
      description = widget.template.description;
    }

    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => CreateSessionFromTemplate(
                      user: widget.user,
                      template: widget.template,
                    )));
      },
      child: Container(
        height: 150,
        child: Card(
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "${widget.template.title}",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _confirmDelete();
                    },
                    icon: Icon(Icons.delete),
                    iconSize: 15,
                    color: Colors.black,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Text(
                  "$description",
                  softWrap: true,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Template'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you would like to delete this?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Ok',
                style: TextStyle(color: Colors.blue[800]),
              ),
              onPressed: () async {
                firestore.deleteTemplate(widget.template.id);
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TemplatePage(
                              user: widget.user,
                              templates: null,
                            )));
              },
            ),
            FlatButton(
              child: Text(
                'CANCEL',
                style: TextStyle(color: Colors.blue[800]),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
