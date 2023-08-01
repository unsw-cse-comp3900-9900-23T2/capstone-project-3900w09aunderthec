import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final int val;
  final String type;
  final Color color;
  const SummaryCard(
      {Key? key, required this.val, required this.type, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: 175,
        child: Stack(
          // used stack to put circle behind the text
          children: [
            // the white circles for decoration
            Positioned(
              right: -30, // adjust this value to move the circle
              top: 35,
              child: Opacity(
                opacity: 0.15,
                child: Container(
                  width: 100, // adjust this value to resize the circle
                  height: 100, // adjust this value to resize the circle
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // the white circles for decoration
            Positioned(
              left: 50,
              bottom: 20,
              child: Opacity(
                opacity: 0.1,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                ),
              ),
            ),
            // content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    val.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    type,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
