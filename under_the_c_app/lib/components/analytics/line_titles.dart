import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 13,
      color: Color.fromARGB(255, 22, 192, 0));
  Widget text;
  switch (value.toInt()) {
    // case 1:
    //   text = const Text('JAN', style: style);
    //   break;
    case 2:
      text = const Text('MAR', style: style);
      break;
    // case 4:
    //   text = const Text('APR', style: style);
    //   break;
    case 5:
      text = const Text('JUN', style: style);
      break;
    // case 7:
    //   text = const Text('JUL', style: style);
    //   break;
    case 8:
      text = const Text('SEP', style: style);
      break;
    // case 10:
    //   text = const Text('OCT', style: style);
    //   break;
    case 11:
      text = const Text('DEC', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}

Widget leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 13,
      color: Color.fromARGB(255, 0, 204, 88));
  String text;
  switch (value.toInt()) {
    case 0:
      text = "0";
      break;
    case 1:
      text = "1";
      break;
    case 2:
      text = "2";
      break;
    case 3:
      text = "3";
      break;
    case 4:
      text = "4";
      break;
    case 5:
      text = "5";
      break;
    default:
      return Container();
  }
  return Text(text, style: style, textAlign: TextAlign.left);
}

class LineTitles {
  static getTitleData() => const FlTitlesData(
        show: true,
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 15,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
      );
}
