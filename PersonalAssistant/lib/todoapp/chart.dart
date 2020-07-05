import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class MyPieChart extends StatefulWidget {
  int completed;
  int notCompleted;
  MyPieChart(this.completed, this.notCompleted);
  @override
  State<StatefulWidget> createState() {
    var datas = [this.completed, this.notCompleted];
    return _MyPieChartState(datas);
  }

}

class _MyPieChartState extends State<MyPieChart> {
  Map <String, double> data = new Map();
  var datas;
  _MyPieChartState(this.datas);
  @override
  void initState() {
    double a = this.datas[0].toDouble();
    double b = this.datas[1].toDouble();
    data.addAll(
      {
        'Completed': a,
        'Not Completed': b,
      }
    );

    super.initState();
  }
  List<Color> _colors = [
    Colors.greenAccent,
    Colors.redAccent,
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: PieChart(
        dataMap: data,
        colorList: _colors,
        animationDuration: Duration(milliseconds: 0),
        chartLegendSpacing: 30.0,
        chartRadius: 140.0,
        showChartValuesInPercentage: true,
        showChartValuesOutside: false,
        chartValueBackgroundColor: Colors.white,
        showLegends: true,
        legendPosition: LegendPosition.right,
        legendStyle: TextStyle(
          color: Colors.white,
          fontFamily: 'Raleway',
          fontSize: 13.0,
        ),
        decimalPlaces: 1,
        showChartValueLabel: true,
        initialAngle: 0,
        chartValueStyle: defaultChartValueStyle.copyWith(
          color: Colors.blueGrey,
        ),
        chartType: ChartType.ring,
      ),
    );
  }

}