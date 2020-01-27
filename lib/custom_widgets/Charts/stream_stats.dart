import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:training_journal/Services/firestore_database.dart';
import 'package:training_journal/custom_widgets/Charts/bar_category_chart.dart';
import 'package:training_journal/stats_manager.dart';
import 'package:training_journal/user.dart';

class StreamStatsCard extends StatefulWidget {
  final String title;
  final User user;
  const StreamStatsCard({
    this.title,
    this.user,
  });

  @override
  _StreamStatsCardState createState() => _StreamStatsCardState();
}

class _StreamStatsCardState extends State<StreamStatsCard> {
  List<BarDataModel> data;
  DatabaseService firestore;
  void initStat() {
    super.initState();
    firestore = DatabaseService(uid: widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(context).size.width - 10, //380,
        height: 280,
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
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder(
                    //stream: firestore.getSummaryData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        data = snapshot.data;
                        return BarCategoryChart(
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
      ),
    );
  }
}
