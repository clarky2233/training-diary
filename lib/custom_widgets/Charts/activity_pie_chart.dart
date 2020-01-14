import 'package:flutter/material.dart';
import 'package:training_journal/stats_manager.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ActivityPieChart extends StatelessWidget {
  final List<BarDataModel> data;

  ActivityPieChart({this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<BarDataModel, String>> series = [
      charts.Series<BarDataModel, String>(
          id: "chart",
          data: data,
          domainFn: (BarDataModel model, _) => model.xValue,
          measureFn: (BarDataModel model, _) => model.yValue,
          colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.blueAccent),
          labelAccessorFn: (BarDataModel model, _) => '${model.xValue}'),
    ];
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: charts.PieChart(series,
          animate: true,
          defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [
            new charts.ArcLabelDecorator(
                labelPosition: charts.ArcLabelPosition.outside)
          ])),
    );
  }
}
