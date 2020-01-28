import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:training_journal/custom_widgets/Charts/time_series_chart.dart';
import 'package:training_journal/stats_manager.dart';

class YearStatsCard extends StatefulWidget {
  final StatsManager sm;
  final String title;
  final String dataColumn;
  const YearStatsCard({
    this.sm,
    this.title,
    this.dataColumn,
  });

  @override
  _YearStatsCardState createState() => _YearStatsCardState();
}

class _YearStatsCardState extends State<YearStatsCard> {
  List<TSDataModel> data;
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
                    "Average: ${widget.sm.tsGraphStats(data)[0].toStringAsFixed(3)}",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Max: ${widget.sm.tsGraphStats(data)[1].toStringAsFixed(3)}",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Min: ${widget.sm.tsGraphStats(data)[2].toStringAsFixed(3)}",
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
        width: MediaQuery.of(context).size.width - 20,
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
                          _showBottomSheet();
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8, 15, 8),
                  child: FutureBuilder(
                    future: widget.sm.getYearData('${widget.dataColumn}'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        data = snapshot.data;
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
      ),
    );
  }
}
