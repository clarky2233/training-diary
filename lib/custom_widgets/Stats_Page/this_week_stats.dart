import 'package:flutter/material.dart';
import 'package:training_journal/custom_widgets/Charts/week_stats_card.dart';
import 'package:training_journal/stats_manager.dart';
import 'package:training_journal/user.dart';

class ThisWeekStats extends StatefulWidget {
  final User user;

  const ThisWeekStats({this.user});

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
            height: 280,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                WeekStatsCard(
                  user: widget.user,
                  title: "Duration (hrs)",
                  dataColumn: 'duration',
                ),
                WeekStatsCard(
                  user: widget.user,
                  title: "Intensity / 5",
                  dataColumn: 'difficulty',
                ),
                WeekStatsCard(
                  user: widget.user,
                  title: "Overall Enjoyment / 5",
                  dataColumn: 'enjoymentRating',
                ),
                WeekStatsCard(
                  user: widget.user,
                  title: "Hours of Sleep",
                  dataColumn: 'hoursOfSleep',
                ),
                WeekStatsCard(
                  user: widget.user,
                  title: "Recovery Heart Rate (bpm)",
                  dataColumn: 'heartRate',
                ),
                WeekStatsCard(
                  user: widget.user,
                  title: "Sleep Rating / 5",
                  dataColumn: 'sleepRating',
                ),
                WeekStatsCard(
                  user: widget.user,
                  title: "RPE (6 - 20)",
                  dataColumn: 'rpe',
                ),
                WeekStatsCard(
                  user: widget.user,
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
