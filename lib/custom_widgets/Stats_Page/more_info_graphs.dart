import 'package:flutter/material.dart';

class MoreInfoChart extends StatefulWidget {
  @override
  _MoreInfoChartState createState() => _MoreInfoChartState();
}

class _MoreInfoChartState extends State<MoreInfoChart> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text("More Info"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
