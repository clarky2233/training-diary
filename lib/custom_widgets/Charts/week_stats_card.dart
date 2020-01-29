import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:training_journal/Services/firestore_database.dart';
import 'package:training_journal/custom_widgets/Charts/bar_category_chart.dart';
import 'package:training_journal/stats_manager.dart';
import 'package:training_journal/user.dart';

class WeekStatsCard extends StatefulWidget {
  final User user;
  final String title;
  final String dataColumn;
  const WeekStatsCard({
    this.user,
    this.title,
    this.dataColumn,
  });

  @override
  _WeekStatsCardState createState() => _WeekStatsCardState();
}

class _WeekStatsCardState extends State<WeekStatsCard> {
  List<BarDataModel> data;
  DatabaseService firestore;

  void initState() {
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
                  child: FutureBuilder(
                    future: firestore.getWeekData('${widget.dataColumn}'),
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
