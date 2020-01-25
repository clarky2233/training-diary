import 'package:flutter/material.dart';
import 'package:training_journal/Services/firestore_database.dart';
import 'package:training_journal/custom_widgets/Advanced_Settings/advanced_session_setttings.dart';
import 'package:training_journal/custom_widgets/Standard_Settings/standard_session_settings.dart';
import 'package:training_journal/Database_helper.dart';
import 'package:training_journal/pages/templates.dart';
import 'package:training_journal/training_session.dart';
import 'package:training_journal/user.dart';

class CreateTemplate extends StatefulWidget {
  final DBHelper db;
  final User user;
  const CreateTemplate({
    @required this.db,
    @required this.user,
  });

  @override
  _CreateTemplateState createState() => _CreateTemplateState();
}

class _CreateTemplateState extends State<CreateTemplate>
    with SingleTickerProviderStateMixin {
  TrainingSession ts = TrainingSession();
  TabController tabController;
  DatabaseService firestore;

  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
    firestore = DatabaseService(uid: widget.user.id);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: Colors.grey[400],
          appBar: AppBar(
            title: Text('New Template'),
            centerTitle: true,
            backgroundColor: Colors.pink[500],
            leading: FlatButton(
              onPressed: () async {
                // FocusScope.of(context).requestFocus(new FocusNode());
                // List<TrainingSession> x = await widget.db.getTemplates();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TemplatePage(
                              db: widget.db,
                              user: widget.user,
                              templates: null,
                            )));
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            bottom: TabBar(
              indicatorColor: Colors.white,
              controller: tabController,
              tabs: <Widget>[
                Tab(
                  text: "Standard",
                ),
                Tab(
                  text: "Advanced",
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: <Widget>[
              StandardSessionSettings(
                db: widget.db,
                user: widget.user,
                ts: ts,
                isEdit: false,
              ),
              AdvancedSessionSettings(
                db: widget.db,
                user: widget.user,
                ts: ts,
                isEdit: false,
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (TrainingSession.isValidTemplate(ts)) {
                ts.userID = widget.user.id;
                firestore.updateTemplate(ts);
                // await widget.db.insertTemplate(ts);
                // List<TrainingSession> x = await widget.db.getTemplates();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TemplatePage(
                              db: widget.db,
                              user: widget.user,
                              templates: null,
                            )));
                //print(await widget.db.getJournal());
              } else {
                _neverSatisfied();
              }
            },
            child: Icon(Icons.done_outline),
            backgroundColor: Colors.pink[600],
          ),
        ),
      ),
    );
  }

  Future<void> _neverSatisfied() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Incomplete Data'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please ensure the title is complete.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Ok',
                style: TextStyle(color: Colors.pink[800]),
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
