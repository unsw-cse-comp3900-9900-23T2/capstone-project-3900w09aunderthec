import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../config/routes/routes.dart';

class CommentSection extends StatefulWidget {
  final String eventId;
  const CommentSection({
    required this.eventId,
    Key? key,
  }) : super(key: key);

  @override
  CommentSectionState createState() {
    return CommentSectionState();
  }
}

class CommentSectionState extends State<CommentSection> {
  double starRating = 3;
  List<String> comments = [];
  final commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  DateTime createdTime = DateTime.now();

  void addComment(String comment) {
    setState(() {
      comments.add(comment);
    });
    _scrollController.jumpTo(_scrollController.position.minScrollExtent);
  }

  void resetStarRating() {
    setState(() {
      starRating = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          AppBar(
            title: null,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => context
                  .go(AppRoutes.eventDetails(widget.eventId), extra: "Details"),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            // color: Colors.grey,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ReviewStar(starRating: starRating, key: UniqueKey()),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: TextField(
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            addComment(commentController.text);
                            resetStarRating();
                            commentController.clear();
                            createdTime = DateTime.now();
                          },
                          icon: Icon(Icons.send),
                        ),
                        border: OutlineInputBorder(),
                        hintText: 'Comment',
                      ),
                      controller: commentController,
                      maxLines: 3,
                    ),
                  ),
                  const Divider(),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final reversedIndex =
                    comments.length - 1 - index; // Reverse the index
                // return Container(
                //   alignment: Alignment.center,
                //   color: Colors.blue,
                //   height: 50,
                //   child: Text(
                //       'Comment: ${comments[reversedIndex]} $reversedIndex'),
                // );
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('images/users/guy.jpg'),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("Date"),
                        IgnorePointer(
                          child: RatingBar.builder(
                            initialRating: 3,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: MediaQuery.of(context).size.width * 0.05,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (double value) => {},
                          ),
                        ),
                        Text(
                            'Comment: ${comments[reversedIndex]} $reversedIndex'),
                        IconButton(
                            onPressed: () {}, icon: Icon(Icons.thumb_up_sharp)),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.thumb_down_sharp)),
                      ],
                    )
                  ],
                );

                // return Container(
                //   height: 50.0,
                //   width: 50.0,
                //   decoration: BoxDecoration(
                //       color: Colors.blue,
                //       borderRadius: BorderRadius.all(Radius.circular(50))),
                //   child: CircleAvatar(
                //     radius: 50,
                //     backgroundImage: AssetImage('images/users/guy.jpg'),
                //   ),
                // );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewStar extends StatefulWidget {
  ReviewStar({Key? key, required this.starRating}) : super(key: key);
  final double starRating;

  @override
  _ReviewStarState createState() => _ReviewStarState();
}

class _ReviewStarState extends State<ReviewStar> {
  late double _starRating;

  @override
  void initState() {
    super.initState();
    _starRating = widget.starRating;
  }

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: _starRating,
      minRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          _starRating = rating;
        });
      },
    );
  }
}

class Comment {
  final String? commentId;
  final String review;
  final int like;
  final int dislike;
  final String imageUrl;

  Comment({
    String? commentId,
    required this.review,
    required this.like,
    required this.dislike,
    String? imageUrl,
  })  : commentId = commentId ?? "",
        imageUrl = imageUrl ?? "images/events/money-event.jpg";
}
