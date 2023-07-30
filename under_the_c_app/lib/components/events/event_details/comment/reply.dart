import 'package:flutter/material.dart';

class Reply extends StatelessWidget {
  const Reply({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        const Divider(),
        // for profile image, name and date of publishing
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 10, bottom: 5),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage("images/users/guy.jpg"),
                radius: 16,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(customer.userName),
                  const Text(
                    "Abraham",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: screenWidth * 0.5,
                    child: const Text(
                      "This is the best content every of the reply laolll",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
