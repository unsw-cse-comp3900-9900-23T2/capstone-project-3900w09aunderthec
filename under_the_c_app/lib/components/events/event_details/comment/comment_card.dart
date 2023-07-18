import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentCart extends ConsumerStatefulWidget {
  const CommentCart({super.key});

  @override
  CommentCartState createState() => CommentCartState();
}

class CommentCartState extends ConsumerState<CommentCart> {
  bool thumbLikeSelected = false;
  bool thumbDislikeSelected = false;
  bool commentSelected = false;
  int nLikes = 0;
  int nDislikes = 0;
  int nComment = 0;

  @override
  initState() {
    super.initState();
  }

  void incrementLikes() {
    setState(() {
      nLikes++;
    });
  }

  void decrementLikes() {
    setState(() {
      nLikes--;
    });
  }

  void incrementDislikes() {
    setState(() {
      nDislikes++;
    });
  }

  void decrementDislikes() {
    setState(() {
      nDislikes--;
    });
  }

  void incrementNComments() {
    setState(() {
      nComment++;
    });
  }

  void decrementNComments() {
    setState(() {
      nComment--;
    });
  }

  void toggleThumbLike() {
    setState(() {
      thumbLikeSelected = !thumbLikeSelected;
    });
  }

  void toggleThumbDislike() {
    setState(() {
      thumbDislikeSelected = !thumbDislikeSelected;
    });
  }

  void toggleComment() {
    setState(() {
      commentSelected = !commentSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
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
                    IconButton(
                      onPressed: () => {
                        toggleThumbLike(),
                        thumbLikeSelected ? incrementLikes() : decrementLikes()
                      },
                      icon: Icon(thumbLikeSelected
                          ? Icons.thumb_up
                          : Icons.thumb_up_alt_outlined),
                      color: thumbLikeSelected
                          ? const Color.fromARGB(255, 255, 17, 0)
                          : Colors.grey,
                    ),
                    Text("$nLikes", style: TextStyle(color: Colors.grey))
                  ],
                ),
                SizedBox(width: 12),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => {
                        toggleThumbDislike(),
                        thumbDislikeSelected
                            ? incrementDislikes()
                            : decrementDislikes()
                      },
                      icon: Icon(thumbDislikeSelected
                          ? Icons.thumb_down
                          : Icons.thumb_down_alt_outlined),
                      color: thumbDislikeSelected ? Colors.blue : Colors.grey,
                    ),
                    Text("$nDislikes", style: TextStyle(color: Colors.grey))
                  ],
                ),
                const SizedBox(width: 12),
                Row(
                  children: [
                    IconButton(
                        onPressed: () => {toggleComment()},
                        icon: Icon(commentSelected
                            ? Icons.comment
                            : Icons.comment_outlined),
                        color: commentSelected
                            ? Color.fromARGB(255, 149, 37, 176)
                            : Colors.grey),
                    Text("$nComment", style: TextStyle(color: Colors.grey))
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
