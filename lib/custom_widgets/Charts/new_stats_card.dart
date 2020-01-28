import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:training_journal/custom_widgets/Charts/bar_category_chart.dart';
import 'package:training_journal/stats_manager.dart';

class NewStatsCard extends StatefulWidget {
  final StatsManager sm;
  final String title;
  final String dataColumn;
  const NewStatsCard({
    this.sm,
    this.title,
    this.dataColumn,
  });
  @override
  _NewStatsCardState createState() => _NewStatsCardState();
}

class _NewStatsCardState extends State<NewStatsCard> {
  List<BarDataModel> data;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width - 10,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(15),
        ),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Center(
              child: Text(
                "${widget.title}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FutureBuilder(
              future: widget.sm.getWeekData('${widget.dataColumn}'),
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
          ],
        ),
      ),
    );
  }
}
