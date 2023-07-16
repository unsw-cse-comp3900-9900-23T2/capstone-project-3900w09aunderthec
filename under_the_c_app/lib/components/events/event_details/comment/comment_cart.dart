import 'package:flutter/material.dart';

class CommentCart extends StatelessWidget {
  const CommentCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // for profile image, name and date of publishing
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("images/users/guy.jpg"),
                  radius: 25,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Mohamed Benar"),
                    SizedBox(height: 4),
                    Text(
                      "March 24, 15:14",
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey, letterSpacing: 0.4),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              "This is a very very long long long comment that I want to talk about",
              style: TextStyle(height: 1.25),
            ),
            SizedBox(height: 15),
            // for like, comment section
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 4),
                    Text("12", style: TextStyle(color: Colors.grey))
                  ],
                ),
                SizedBox(width: 14),
                Row(
                  children: [
                    Icon(Icons.comment_outlined, color: Colors.grey),
                    SizedBox(width: 6),
                    Text("5", style: TextStyle(color: Colors.grey))
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
