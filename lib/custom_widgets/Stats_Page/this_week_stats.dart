import 'package:flutter/material.dart';
import 'package:training_journal/custom_widgets/Charts/new_stats_card.dart';
import 'package:training_journal/custom_widgets/Charts/week_stats_card.dart';
import 'package:training_journal/stats_manager.dart';

class ThisWeekStats extends StatefulWidget {
  final StatsManager sm;

  const ThisWeekStats({this.sm});

  @override
  _ThisWeekStatsState createState() => _ThisWeekStatsState();
}

class _ThisWeekStatsState extends State<ThisWeekStats> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
          child: Text(
            "This Week",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height - 200, //580,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                WeekStatsCard(
                  sm: widget.sm,
                  title: "Duration (hrs)",
                  dataColumn: 'duration',
                ),
                WeekStatsCard(
                  sm: widget.sm,
                  title: "Intensity / 5",
                  dataColumn: 'difficulty',
                ),
                WeekStatsCard(
                  sm: widget.sm,
                  title: "Overall Enjoyment / 5",
                  dataColumn: 'enjoymentRating',
                ),
                WeekStatsCard(
                  sm: widget.sm,
                  title: "Hours of Sleep",
                  dataColumn: 'hoursOfSleep',
                ),
                WeekStatsCard(
                  sm: widget.sm,
                  title: "Recovery Heart Rate (bpm)",
                  dataColumn: 'heartRate',
                ),
                WeekStatsCard(
                  sm: widget.sm,
                  title: "Sleep Rating / 5",
                  dataColumn: 'sleepRating',
                ),
                WeekStatsCard(
                  sm: widget.sm,
                  title: "RPE (6 - 20)",
                  dataColumn: 'rpe',
                ),
                WeekStatsCard(
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
