import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:training_journal/custom_widgets/Charts/activity_pie_chart.dart';
import 'package:training_journal/stats_manager.dart';

class WeekStatsPieCard extends StatefulWidget {
  final StatsManager sm;
  final String title;
  final String dataColumn;
  const WeekStatsPieCard({
    this.sm,
    this.title,
    this.dataColumn,
  });

  @override
  _WeekStatsPieCardState createState() => _WeekStatsPieCardState();
}

class _WeekStatsPieCardState extends State<WeekStatsPieCard> {
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
                  future: widget.sm.getWeekData('${widget.dataColumn}'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ActivityPieChart(
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
