import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:training_journal/Services/firestore_database.dart';
import 'package:training_journal/custom_widgets/Charts/time_series_chart.dart';
import 'package:training_journal/stats_manager.dart';
import 'package:training_journal/user.dart';

class YearStatsCard extends StatefulWidget {
  final User user;
  final String title;
  final String dataColumn;
  const YearStatsCard({
    this.user,
    this.title,
    this.dataColumn,
  });

  @override
  _YearStatsCardState createState() => _YearStatsCardState();
}

class _YearStatsCardState extends State<YearStatsCard> {
  DatabaseService firestore;
  void initState() {
    super.initState();
    firestore = DatabaseService(uid: widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 20, //380,
      height: MediaQuery.of(context).size.height - 200, //280,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        "${widget.title}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: IconButton(
                      icon: Icon(Icons.expand_more),
                      onPressed: () {
                        //_showBottomSheet();
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                  future: firestore.getYearData('${widget.dataColumn}'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return TSChart(
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
