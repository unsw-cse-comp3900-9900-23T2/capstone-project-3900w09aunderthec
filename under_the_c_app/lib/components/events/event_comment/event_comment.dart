import 'package:flutter/material.dart';
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
  // final _formKey = GlobalKey<FormState>();
  double starRating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(children: [
          SingleChildScrollView(
              child: Column(children: [
            AppBar(
              title: null,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => context.go(
                    AppRoutes.eventDetails(widget.eventId),
                    extra: "Details"),
              ),
            ),
            RatingBar.builder(
              initialRating: 3,
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
                starRating = rating;
              },
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: const TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Comment',
                ),
              ),
            ),
          ]))
        ]));
  }
}
