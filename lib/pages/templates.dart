import 'package:flutter/material.dart';
import 'package:training_journal/Database_helper.dart';
import 'package:training_journal/custom_widgets/Templates/template_card.dart';
import 'package:training_journal/event.dart';
import 'package:training_journal/pages/create_session.dart';
import 'package:training_journal/pages/create_template.dart';
import 'package:training_journal/pages/home.dart';
import 'package:training_journal/training_session.dart';
import 'package:training_journal/user.dart';

class TemplatePage extends StatefulWidget {

  final DBHelper db;
  final User user;
  final List<TrainingSession> templates;
  const TemplatePage({@required this.db, @required this.user, @required this.templates});

  @override
  _TemplatePageState createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage> {

  void initState() {
    super.initState();
    if (widget.templates != null) {
      size = widget.templates.length;
    }
  }

  int size = 0;
  bool shouldCLear = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: Colors.grey[300],
          appBar: AppBar(
            leading: FlatButton(
              onPressed: () async {
                FocusScope.of(context).requestFocus(new FocusNode());
                Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                  builder: (context) => CreateSession(db: widget.db, user: widget.user,)
                )
              );
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                onPressed: () async {
                List<TrainingSession> x = await widget.db.lastTenSessions();
                List<Event> upcoming = await widget.db.getEvents();
                Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                  builder: (context) => Home(db: widget.db, user: widget.user, recentTen: x, upcoming: upcoming,)
                )
              );
                },
                icon: Icon(Icons.home), color: Colors.black, iconSize: 30,
            ),
              ),
            ],
            backgroundColor: Colors.grey[300],
            elevation: 0,
            title: Text(
              "My Templates",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
              child: Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: ListView.builder(
                itemCount: size,
                itemBuilder: (context, index) {
                  return Hero(tag: 'TC$index', child: TemplateCard(db: widget.db, user: widget.user, template: widget.templates[index],));
                  },
                ),
            ),
            )
            ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                  builder: (context) => CreateTemplate(db: widget.db, user: widget.user,)
                )
              );
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.red[600],
            elevation: 2,
          ),
        ),
      ),
    );
  }
}