import 'package:flutter/material.dart';
import 'package:training_journal/custom_widgets/Charts/month_stats_card.dart';
import 'package:training_journal/user.dart';

class ThisMonthStats extends StatefulWidget {
  final User user;
  final bool thisMonth;
  const ThisMonthStats({this.user, this.thisMonth});

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
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
          child: Container(
            height: MediaQuery.of(context).size.height - 200, //580,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                MonthStatsCard(
                  user: widget.user,
                  title: "Duration (hrs)",
                  dataColumn: 'duration',
                  thisMonth: widget.thisMonth,
                ),
                MonthStatsCard(
                  user: widget.user,
                  title: "Intensity / 5",
                  dataColumn: 'difficulty',
                  thisMonth: widget.thisMonth,
                ),
                MonthStatsCard(
                  user: widget.user,
                  title: "Overall Enjoyment / 5",
                  dataColumn: 'enjoymentRating',
                  thisMonth: widget.thisMonth,
                ),
                MonthStatsCard(
                  user: widget.user,
                  title: "Hours of Sleep",
                  dataColumn: 'hoursOfSleep',
                  thisMonth: widget.thisMonth,
                ),
                MonthStatsCard(
                  user: widget.user,
                  title: "Recovery Heart Rate (bpm)",
                  dataColumn: 'heartRate',
                  thisMonth: widget.thisMonth,
                ),
                MonthStatsCard(
                  user: widget.user,
                  title: "Sleep Rating / 5",
                  dataColumn: 'sleepRating',
                  thisMonth: widget.thisMonth,
                ),
                MonthStatsCard(
                  user: widget.user,
                  title: "RPE (6 - 20)",
                  dataColumn: 'rpe',
                  thisMonth: widget.thisMonth,
                ),
                MonthStatsCard(
                  user: widget.user,
                  title: "Hydration (Litres)",
                  dataColumn: 'hydration',
                  thisMonth: widget.thisMonth,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
