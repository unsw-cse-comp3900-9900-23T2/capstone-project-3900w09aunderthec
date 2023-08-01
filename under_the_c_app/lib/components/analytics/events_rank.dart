import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class EventsRank extends StatelessWidget {
  final double percentage;
  final Color color;
  final String title;
  const EventsRank(
      {Key? key,
      required this.percentage,
      required this.color,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String percentageText = (percentage * 100).toStringAsFixed(0);
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 42, 23, 120)),
          ),
          const SizedBox(height: 15),
          CircularPercentIndicator(
            radius: 55.0,
            lineWidth: 13.0,
            percent: percentage,
            animation: true,
            animationDuration: 2000,
            circularStrokeCap: CircularStrokeCap.round,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "You've beaten",
                  style: TextStyle(fontSize: 9, color: Colors.grey),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      percentageText,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 79, 137, 236)),
                    ),
                    Text(
                      "%",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ],
                ),
                Text(
                  "hosts",
                  style: TextStyle(fontSize: 9, color: Colors.grey),
                ),
              ],
            ),
            progressColor: color,
          )
        ],
      ),
    ));
  }
}
