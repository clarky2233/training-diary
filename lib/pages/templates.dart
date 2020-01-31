import 'package:flutter/material.dart';
import 'package:training_journal/Services/firestore_database.dart';
import 'package:training_journal/custom_widgets/Templates/template_card.dart';
import 'package:training_journal/pages/create_session.dart';
import 'package:training_journal/pages/create_template.dart';
import 'package:training_journal/pages/home_2.dart';
import 'package:training_journal/training_session.dart';
import 'package:training_journal/user.dart';

class TemplatePage extends StatefulWidget {
  final User user;
  final List<TrainingSession> templates;
  const TemplatePage({@required this.user, @required this.templates});

  @override
  _TemplatePageState createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage> {
  DatabaseService firestore;
  void initState() {
    super.initState();
    firestore = DatabaseService(uid: widget.user.id);
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
                        builder: (context) => CreateSession(
                              user: widget.user,
                            )));
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                  onPressed: () async {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Home2(
                                  user: widget.user,
                                )));
                  },
                  icon: Icon(Icons.home),
                  color: Colors.white,
                  iconSize: 30,
                ),
              ),
            ],
            backgroundColor: Colors.redAccent,
            elevation: 0,
            title: Text(
              "My Templates",
              style: TextStyle(
                color: Colors.white,
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
                    child: StreamBuilder<List<TrainingSession>>(
                        stream: firestore.templates,
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return Container();
                          }
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Hero(
                                  tag: 'TC$index',
                                  child: TemplateCard(
                                    user: widget.user,
                                    template: snapshot.data[index],
                                  ));
                            },
                          );
                        }),
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
                      builder: (context) => CreateTemplate(
                            user: widget.user,
                          )));
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
