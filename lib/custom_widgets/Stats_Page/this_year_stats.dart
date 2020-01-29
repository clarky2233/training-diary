import 'package:flutter/material.dart';
import 'package:training_journal/custom_widgets/Charts/year_stats_card.dart';
import 'package:training_journal/user.dart';

class ThisYearStats extends StatefulWidget {
  final User user;
  final bool thisYear;
  const ThisYearStats({this.user, this.thisYear});

  @override
  _ThisYearStatsState createState() => _ThisYearStatsState();
}

class _ThisYearStatsState extends State<ThisYearStats> {
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
                YearStatsCard(
                  user: widget.user,
                  title: "Duration (hrs)",
                  dataColumn: 'duration',
                  thisYear: widget.thisYear,
                ),
                YearStatsCard(
                  user: widget.user,
                  title: "Intensity / 5",
                  dataColumn: 'difficulty',
                  thisYear: widget.thisYear,
                ),
                YearStatsCard(
                  user: widget.user,
                  title: "Overall Enjoyment / 5",
                  dataColumn: 'enjoymentRating',
                  thisYear: widget.thisYear,
                ),
                YearStatsCard(
                  user: widget.user,
                  title: "Hours of Sleep",
                  dataColumn: 'hoursOfSleep',
                  thisYear: widget.thisYear,
                ),
                YearStatsCard(
                  user: widget.user,
                  title: "Recovery Heart Rate (bpm)",
                  dataColumn: 'heartRate',
                  thisYear: widget.thisYear,
                ),
                YearStatsCard(
                  user: widget.user,
                  title: "Sleep Rating / 5",
                  dataColumn: 'sleepRating',
                  thisYear: widget.thisYear,
                ),
                YearStatsCard(
                  user: widget.user,
                  title: "RPE (6 - 20)",
                  dataColumn: 'rpe',
                  thisYear: widget.thisYear,
                ),
                YearStatsCard(
                  user: widget.user,
                  title: "Hydration (Litres)",
                  dataColumn: 'hydration',
                  thisYear: widget.thisYear,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
