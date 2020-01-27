import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:training_journal/Database_helper.dart';
import 'package:training_journal/Services/firestore_database.dart';
import 'package:training_journal/custom_widgets/All_Entries/clear_filter.dart';
import 'package:training_journal/custom_widgets/All_Entries/date_filter.dart';
import 'package:training_journal/custom_widgets/All_Entries/small_session_card.dart';
import 'package:training_journal/event.dart';
import 'package:training_journal/pages/home.dart';
import 'package:training_journal/pages/home_2.dart';
import 'package:training_journal/training_session.dart';
import 'package:training_journal/user.dart';

class EntriesPage extends StatefulWidget {
  final DBHelper db;
  final User user;
  final DateTime currentFilter;
  const EntriesPage(
      {@required this.db, @required this.user, this.currentFilter});

  @override
  _EntriesPageState createState() => _EntriesPageState();
}

class _EntriesPageState extends State<EntriesPage> {
  DatabaseService firestore;
  void initState() {
    super.initState();
    firestore = DatabaseService(uid: widget.user.id);
    if (widget.currentFilter != null) {
      filterText = DateFormat.yMMMM("en_US").format(widget.currentFilter);
    }
  }

  int size = 0;
  String filterText = "All";
  bool shouldCLear = true;

  @override
  Widget build(BuildContext context) {
    if (filterText == "All") {
      shouldCLear = false;
    }
    return MaterialApp(
      home: WillPopScope(
        onWillPop: () {
          return;
          Future.value(false);
        },
        child: Scaffold(
          backgroundColor: Colors.grey[300],
          appBar: AppBar(
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Home2(
                                  db: widget.db,
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
              "My Diary",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Text("Filter"),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(Icons.tune),
                              ),
                            ],
                          ),
                        ),
                      ),
                      DateFilter(
                        db: widget.db,
                        user: widget.user,
                      ),
                      ClearFilter(
                        db: widget.db,
                        user: widget.user,
                        shouldClear: shouldCLear,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Showing: $filterText",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                StreamBuilder<List<TrainingSession>>(
                    stream: firestore.filtered(widget.currentFilter),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return Container(
                          height: MediaQuery.of(context).size.height / 2,
                          child: Center(
                            child: Text("Your diary is empty"),
                          ),
                        );
                      }
                      return GridView.count(
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          padding: const EdgeInsets.all(10),
                          crossAxisCount: 2,
                          children:
                              List.generate(snapshot.data.length, (index) {
                            return Hero(
                              tag: "SMC$index",
                              child: SmallSessionCard(
                                ts: snapshot.data[index],
                                db: widget.db,
                                user: widget.user,
                              ),
                            );
                          }));
                    }),
              ],
            ),
          ),
          // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     _confirmDelete();
          //   },
          //   child: Icon(Icons.delete),
          //   backgroundColor: Colors.red[600],
          //   elevation: 2,
          // ),
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
          title: Text('Delete Training Sessions'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    "This will delete all training sessions in the current filter.\n"),
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
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return EntriesPage(
                      db: widget.db,
                      user: widget.user,
                      currentFilter: null,
                    );
                  }));
                }),
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
