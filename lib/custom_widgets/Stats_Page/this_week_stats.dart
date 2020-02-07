import 'package:flutter/material.dart';
import 'package:training_journal/custom_widgets/Charts/week_stats_card.dart';
import 'package:training_journal/user.dart';

class ThisWeekStats extends StatefulWidget {
  final User user;
  final bool thisWeek;
  const ThisWeekStats({this.user, this.thisWeek});

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
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
          child: Container(
            height: MediaQuery.of(context).size.height - 200, //580,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                WeekStatsCard(
                  user: widget.user,
                  title: "Duration (hrs)",
                  dataColumn: 'duration',
                  thisWeek: widget.thisWeek,
                ),
                WeekStatsCard(
                  user: widget.user,
                  title: "Intensity / 5",
                  dataColumn: 'difficulty',
                  thisWeek: widget.thisWeek,
                ),
                WeekStatsCard(
                  user: widget.user,
                  title: "Overall Enjoyment / 5",
                  dataColumn: 'enjoymentRating',
                  thisWeek: widget.thisWeek,
                ),
                WeekStatsCard(
                  user: widget.user,
                  title: "Hours of Sleep",
                  dataColumn: 'hoursOfSleep',
                  thisWeek: widget.thisWeek,
                ),
                WeekStatsCard(
                  user: widget.user,
                  title: "Recovery Heart Rate (bpm)",
                  dataColumn: 'heartRate',
                  thisWeek: widget.thisWeek,
                ),
                WeekStatsCard(
                  user: widget.user,
                  title: "Sleep Rating / 5",
                  dataColumn: 'sleepRating',
                  thisWeek: widget.thisWeek,
                ),
                WeekStatsCard(
                  user: widget.user,
                  title: "RPE (6 - 20)",
                  dataColumn: 'rpe',
                  thisWeek: widget.thisWeek,
                ),
                WeekStatsCard(
                  user: widget.user,
                  title: "Hydration (Litres)",
                  dataColumn: 'hydration',
                  thisWeek: widget.thisWeek,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
