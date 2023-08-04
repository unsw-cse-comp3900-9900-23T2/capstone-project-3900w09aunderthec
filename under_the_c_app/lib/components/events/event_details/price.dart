import 'package:flutter/material.dart';

class PriceTag extends StatelessWidget {
  final double price;

  const PriceTag({
    Key? key,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        // color: Colors.grey,
        padding: const EdgeInsets.only(top: 3, left: 0, right: 8, bottom: 3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color.fromARGB(255, 217, 226, 232)),
        child: Row(
          children: <Widget>[
            const Icon(
              Icons.attach_money,
              color: Color.fromARGB(255, 7, 7, 7),
              size: 16,
            ), // your custom style here
            const SizedBox(width: 6),
            Text(price.toStringAsFixed(2),
                style: const TextStyle(fontSize: 15.0)),
          ],
        ),
      ),
    );
  }
}
