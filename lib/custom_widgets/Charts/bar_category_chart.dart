import 'package:flutter/material.dart';
import 'package:training_journal/Services/firestore_database.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BarCategoryChart extends StatelessWidget {
  final List<BarDataModel> data;

  BarCategoryChart({this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<BarDataModel, String>> series = [
      charts.Series<BarDataModel, String>(
          id: "chart",
          data: data,
          domainFn: (BarDataModel model, _) => model.xValue,
          measureFn: (BarDataModel model, _) => model.yValue,
          colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.redAccent),
          labelAccessorFn: (BarDataModel model, _) =>
              '${model.yValue.toStringAsFixed(1)}'),
    ];
    return Container(
      height: MediaQuery.of(context).size.height - 300, //200,
      width: MediaQuery.of(context).size.width,
      child: charts.BarChart(
        series,
        animate: true,
        barRendererDecorator: new charts.BarLabelDecorator<String>(),
        barGroupingType: charts.BarGroupingType.grouped,
      ),
    );
  }
}
