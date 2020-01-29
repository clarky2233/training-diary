import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:training_journal/Services/firestore_database.dart';
import 'package:training_journal/custom_widgets/Charts/grouped_bar_chart.dart';
import 'package:training_journal/user.dart';

class SummaryStatsCard extends StatefulWidget {
  final User user;
  final String title;
  const SummaryStatsCard({
    this.user,
    this.title,
  });

  @override
  _SummaryStatsCardState createState() => _SummaryStatsCardState();
}

class _SummaryStatsCardState extends State<SummaryStatsCard> {
  DatabaseService firestore;

  void initState() {
    super.initState();
    firestore = DatabaseService(uid: widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 20, //380,
      height: 320,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(15),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Center(
                  child: Text(
                    "${widget.title}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                child: FutureBuilder(
                  future: firestore.getSummaryData(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return SpinKitDualRing(
                        color: Colors.blueAccent,
                        size: 70,
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      return GroupedBarChart(
                        data: snapshot.data,
                      );
                    } else {
                      return SpinKitDualRing(
                        color: Colors.blueAccent,
                        size: 70,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
