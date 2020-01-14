import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:training_journal/custom_widgets/Charts/time_series_chart.dart';
import 'package:training_journal/stats_manager.dart';

class MonthStatsCard extends StatefulWidget {
  final StatsManager sm;
  final String title;
  final String dataColumn;
  const MonthStatsCard({
    this.sm,
    this.title,
    this.dataColumn,
  });

  @override
  _MonthStatsCardState createState() => _MonthStatsCardState();
}

class _MonthStatsCardState extends State<MonthStatsCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
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
                  future: widget.sm.getMonthData('${widget.dataColumn}'),
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
