import 'package:flutter/material.dart';
import 'package:training_journal/Services/firestore_database.dart';
import 'package:training_journal/custom_widgets/Advanced_Settings/advanced_session_setttings.dart';
import 'package:training_journal/custom_widgets/Standard_Settings/standard_session_settings.dart';
import 'package:training_journal/pages/home_2.dart';
import 'package:training_journal/pages/templates.dart';
import 'package:training_journal/training_session.dart';
import 'package:training_journal/user.dart';

class CreateSessionFromTemplate extends StatefulWidget {
  final User user;
  final TrainingSession template;
  const CreateSessionFromTemplate({@required this.user, this.template});

  @override
  _CreateSessionFromTemplateState createState() =>
      _CreateSessionFromTemplateState();
}

class _CreateSessionFromTemplateState extends State<CreateSessionFromTemplate>
    with SingleTickerProviderStateMixin {
  TrainingSession ts = TrainingSession();
  TabController tabController;
  DatabaseService firestore;

  void initState() {
    tabController = TabController(length: 2, vsync: this);
    if (widget.template != null) {
      ts = widget.template;
    }
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
            title: Text('New Training Session'),
            centerTitle: true,
            backgroundColor: Colors.redAccent,
            leading: FlatButton(
              onPressed: () async {
                FocusScope.of(context).requestFocus(new FocusNode());
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home2(
                              user: widget.user,
                            )));
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.save),
                onPressed: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TemplatePage(
                                user: widget.user,
                                templates: null,
                              )));
                },
              ),
            ],
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
                user: widget.user,
                ts: widget.template,
                isEdit: true,
              ),
              AdvancedSessionSettings(
                user: widget.user,
                ts: widget.template,
                isEdit: true,
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (TrainingSession.isValid(ts)) {
                ts.id = null;
                ts.userID = widget.user.id;
                firestore.updateTrainingSession(ts);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home2(
                              user: widget.user,
                            )));
              } else {
                _neverSatisfied();
              }
            },
            child: Icon(Icons.done_outline),
            backgroundColor: Colors.redAccent,
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
                Text('Please complete all available fields.'),
                Text('The Description field is optional.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Ok',
                style: TextStyle(color: Colors.redAccent),
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
