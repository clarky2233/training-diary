import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:training_journal/Services/firestore_database.dart';
import 'package:training_journal/custom_widgets/All_Entries/clear_filter.dart';
import 'package:training_journal/custom_widgets/All_Entries/date_filter.dart';
import 'package:training_journal/custom_widgets/All_Entries/small_session_card.dart';
import 'package:training_journal/pages/home_2.dart';
import 'package:training_journal/training_session.dart';
import 'package:training_journal/user.dart';

class EntriesPage extends StatefulWidget {
  final User user;
  final DateTime currentFilter;
  const EntriesPage({@required this.user, this.currentFilter});

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
                            builder: (context) => Home(
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
            centerTitle: false,
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
                        user: widget.user,
                      ),
                      ClearFilter(
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
                                user: widget.user,
                              ),
                            );
                          }));
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
