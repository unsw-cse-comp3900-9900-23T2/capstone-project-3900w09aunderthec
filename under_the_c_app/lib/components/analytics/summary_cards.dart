import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:under_the_c_app/components/analytics/summary_card.dart';

class SummaryCards extends StatelessWidget {
  const SummaryCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Summary",
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 42, 23, 120)),
        ),
        const SizedBox(height: 10),
        Container(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              SummaryCard(
                  val: 25,
                  type: "Events Hosted",
                  color: Color.fromARGB(255, 96, 98, 255)),
              SizedBox(
                width: 15,
              ),
              SummaryCard(
                  val: 10,
                  type: "Subscribers",
                  color: Color.fromARGB(255, 255, 119, 41)),
            ],
          ),
        ),
      ],
    );
  }
}
