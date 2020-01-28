import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:training_journal/custom_widgets/Charts/bar_category_chart.dart';
import 'package:training_journal/stats_manager.dart';

class WeekStatsCard extends StatefulWidget {
  final StatsManager sm;
  final String title;
  final String dataColumn;
  const WeekStatsCard({
    this.sm,
    this.title,
    this.dataColumn,
  });

  @override
  _WeekStatsCardState createState() => _WeekStatsCardState();
}

class _WeekStatsCardState extends State<WeekStatsCard> {
  List<BarDataModel> data;
  Icon stat_icon = Icon(Icons.expand_more);
  @override
  Widget build(BuildContext context) {
    void _showBottomSheet() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 60, 0, 30.0),
                  child: Text(
                    "Graph Analysis for ${widget.title}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Average: ${widget.sm.barGraphStats(data)[0].toStringAsFixed(3)}",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Max: ${widget.sm.barGraphStats(data)[1].toStringAsFixed(3)}",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Min: ${widget.sm.barGraphStats(data)[2].toStringAsFixed(3)}",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            );
          });
    }

    return GestureDetector(
      onTap: () {
        _showBottomSheet();
      },
      child: Container(
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
                        icon: stat_icon,
                        onPressed: () {
                          _showBottomSheet();
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String capitalise(String s) {
    return s[0].toUpperCase() + s.substring(1);
  }
}
