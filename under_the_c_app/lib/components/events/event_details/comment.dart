import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  const Comment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // title
        Text(
          "Comments",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(221, 5, 5, 5),
          ),
        ),
        SizedBox(height: 15),
        // "What do you want to talk about" seciton
        Column(
          children: [
            Row(
              children: [
                // for profile picture
                const CircleAvatar(
                  backgroundImage: AssetImage('images/users/guy.jpg'),
                  radius: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  // for the "name" and "public"
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Ersad Basbag"),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.public,
                            size: 17,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Public",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                letterSpacing: 0.5),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'What do you want to talk about?',
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 3),
              ),
            )
          ],
        )
      ],
    );
  }
}
