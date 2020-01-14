import 'package:flutter/material.dart';
import 'package:training_journal/custom_widgets/Charts/month_stats_card.dart';
import 'package:training_journal/stats_manager.dart';

class ThisMonthStats extends StatefulWidget {
  final StatsManager sm;

  const ThisMonthStats({this.sm});

  @override
  _ThisMonthStatsState createState() => _ThisMonthStatsState();
}

class _ThisMonthStatsState extends State<ThisMonthStats> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
          child: Text(
            "This Month",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 280,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                MonthStatsCard(
                  sm: widget.sm,
                  title: "Duration (hrs)",
                  dataColumn: 'duration',
                ),
                MonthStatsCard(
                  sm: widget.sm,
                  title: "Intensity / 5",
                  dataColumn: 'difficulty',
                ),
                MonthStatsCard(
                  sm: widget.sm,
                  title: "Hours of Sleep",
                  dataColumn: 'hoursOfSleep',
                ),
                MonthStatsCard(
                  sm: widget.sm,
                  title: "Recovery Heart Rate (bpm)",
                  dataColumn: 'heartRate',
                ),
                MonthStatsCard(
                  sm: widget.sm,
                  title: "Sleep Rating / 5",
                  dataColumn: 'sleepRating',
                ),
                MonthStatsCard(
                  sm: widget.sm,
                  title: "RPE (6 - 20)",
                  dataColumn: 'rpe',
                ),
                MonthStatsCard(
                  sm: widget.sm,
                  title: "Hydration (Litres)",
                  dataColumn: 'hydration',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
