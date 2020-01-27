import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:training_journal/Services/firestore_database.dart';
import 'package:training_journal/stats_manager.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TSChart extends StatelessWidget {
  final List<TSDataModel> data;

  TSChart({this.data});

  @override
  Widget build(BuildContext context) {
    List<Series<TSDataModel, DateTime>> series = [
      Series(
        id: "Duration Recent",
        data: data,
        domainFn: (TSDataModel model, _) => model.xValue,
        measureFn: (TSDataModel model, _) => model.yValue,
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.blueAccent),
      )
    ];
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: TimeSeriesChart(
        series,
        animate: true,
      ),
    );
  }
}
